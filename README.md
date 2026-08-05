# Estoque — App de Gestão de Armazém

Aplicativo Flutter multiplataforma (Android, iOS, Web, Windows, Linux, macOS) para controlar o
estoque de um armazém: cadastro de produtos, entrada e saída de itens, leitura de código de barras
e controle de usuários por empresa (multi-tenant), com autenticação e persistência via Supabase.

## Visão geral

- **Login / cadastro** por e-mail e senha, com criação de uma nova empresa ou entrada em uma
  empresa existente via código.
- **Dashboard inicial** com resumo do estoque e atalhos, adaptado conforme o usuário é admin ou não.
- **Cadastro de produtos** (nome, quantidade inicial e código de barras), com leitura de código de
  barras pela câmera.
- **Listagem e busca de produtos**, com detalhe individual de cada item.
- **Entrada de estoque** (soma quantidade a um produto existente).
- **Saída de estoque** (retira/coleta quantidade de um produto existente).
- **Remoção definitiva de produtos** (apenas admin).
- **Configurações**: alternância de tema claro/escuro e logout.
- Cada movimentação registra quem adicionou/alterou o produto e quando, exibido na tela de detalhe.

## Stack técnica

| Camada | Tecnologia |
|---|---|
| UI / Framework | Flutter (Material 3) |
| Gerência de estado | `flutter_bloc` / `bloc` (Bloc e Cubit) |
| Backend | [Supabase](https://supabase.com) (Auth + Edge Functions) |
| Leitura de código de barras | `mobile_scanner` |
| Preferências locais | `shared_preferences` |
| Logs | `logger` |
| Testes | `flutter_test` + testes de golden (screenshot) |

> Toda a persistência (login e produtos) acontece no Supabase. A sessão do usuário é mantida entre
> aberturas do app automaticamente pelo `supabase_flutter`, que já cuida do armazenamento local da
> sessão internamente — não é necessário nenhum código ou dependência própria para isso.

## Arquitetura

O app segue **Clean Architecture**, dividido em três camadas dentro de [`lib/`](lib):

```
lib/
├── app/            # Widget raiz (MaterialApp, tema, rotas)
├── core/            # Constantes, strings, fontes, assets, logger, config do Supabase
├── domain/          # Regra de negócio pura (entidades, contratos de repositório, casos de uso)
│   ├── entities/
│   ├── repositories/    # Interfaces abstratas
│   └── usecases/
├── data/            # Implementação concreta de acesso a dados
│   ├── datasources/     # Chamadas ao Supabase (Auth + Edge Functions) e SQLite legado
│   ├── models/          # Serialização de/para os dados remotos
│   └── repositories/    # Implementações dos contratos de domain/repositories
└── presentation/     # Telas, widgets e Blocs/Cubits (estado da UI)
    ├── blocs/
    ├── routes/
    ├── screens/
    └── widgets/
```

O fluxo de dependência é sempre `presentation → domain ← data`: a UI só conhece casos de uso e
entidades do `domain`; `data` implementa os contratos definidos em `domain` sem que este saiba como
os dados são obtidos (Supabase, banco local, etc.).

## Parte por parte do app

### `lib/main.dart`
Ponto de entrada. Inicializa o Supabase (`Supabase.initialize`), monta manualmente a árvore de
injeção de dependências (data source → repository → caso de uso → Bloc) e sobe o `MultiBlocProvider`
com `AuthBloc`, `ProductBloc`, `BarcodeBloc` e `ThemeCubit` disponíveis para todo o app.

### `lib/app/warehouse_app.dart`
Define o `MaterialApp`: temas claro/escuro (`ColorScheme.fromSeed`), o mapa de rotas nomeadas
(`AppRoutes`) e a tela inicial, que é escolhida dinamicamente conforme o `AuthState`:
- `AuthAuthenticatedState` → `HomeScreen`
- `AuthInitialState` / `AuthLoadingState` → `SplashScreen`
- qualquer outro estado → `LoginScreen`

A troca entre essas telas é animada com `AnimatedSwitcher`.

### `lib/domain` — regra de negócio
- **Entidades**: `Product` (nome, quantidade, código de barras, quem adicionou/atualizou e quando)
  e `User` (id, e-mail, código da empresa, se é admin).
- **Repositórios (contratos)**: `AuthRepository` (login, registro, logout, usuário logado) e
  `ProductRepository` (carregar, adicionar, aumentar/coletar quantidade, deletar).
- **Casos de uso**: uma classe por ação de negócio (`Login`, `Register`, `Logout`,
  `GetLoggedUser`, `LoadProducts`, `AddProduct`, `IncreaseProductQuantity`, `CollectProduct`/
  `RemoveProduct`, `DeleteProduct`), cada uma encapsulando uma única chamada ao repositório.

### `lib/data` — acesso a dados
- **`AuthSupabaseDataSource`**: autentica via `supabase_flutter` (`signInWithPassword`) e delega
  registro/perfil para *Edge Functions* do Supabase (`auth-register`, `auth-profile`), que criam
  usuário, empresa e perfil de forma atômica no lado do servidor.
- **`ProductSupabaseDataSource`**: chama *Edge Functions* (`products-list`, `products-add`,
  `products-increase`, `products-decrease`, `products-delete`) em vez de acessar tabelas
  diretamente, mantendo a lógica sensível (permissões, validações) no backend.
- **`AuthRepositoryImpl` / `ProductRepositoryImpl`**: implementam os contratos do `domain`
  convertendo os `Map<String, dynamic>` vindos do Supabase em `User`/`Product`.

### `lib/presentation` — interface e estado
Estado gerenciado com **Bloc/Cubit** (`flutter_bloc`):
- **`AuthBloc`**: eventos `CheckAuthEvent`, `LoginEvent`, `RegisterEvent`, `LogoutEvent`; estados
  `AuthInitialState`, `AuthLoadingState`, `AuthAuthenticatedState`, `AuthUnauthenticatedState`,
  `AuthErrorState`. Verifica a sessão automaticamente ao ser criado.
- **`ProductBloc`**: eventos `LoadProductEvent`, `AddProductEvent`, `CollectProductEvent`,
  `UpdateStockEvent`, `DeleteProductEvent`; estados `ProductInitialState`, `ProductSuccessState`
  (lista de produtos) e `ProductErrorState`.
- **`BarcodeBloc`**: guarda o último código de barras lido pela câmera.
- **`ThemeCubit`**: alterna entre `ThemeMode.light`/`ThemeMode.dark` (padrão: `system`).

Telas em [`lib/presentation/screens/`](lib/presentation/screens):

| Tela | Arquivo | Função |
|---|---|---|
| Splash | `splash/splash_screen.dart` | Tela de carregamento exibida enquanto o `AuthBloc` verifica a sessão. |
| Login / Cadastro | `login/login_screen.dart` | Login e registro; no registro, escolhe entre criar uma nova empresa ou entrar em uma existente com um código. |
| Início | `home/home_screen.dart` | Resumo do estoque, navegação inferior (Início/Produtos/Entrada/Saída/Config.) e menu lateral com dados do usuário, código da empresa e ações de admin. |
| Lista de produtos | `product_list/product_list_screen.dart` | Lista com busca por nome; toque leva ao detalhe do produto. |
| Detalhe do produto | `product_detail/product_detail_screen.dart` | Quantidade em destaque, atalhos de entrada/saída rápida e histórico da última movimentação (quem e quando). |
| Cadastrar produto | `new_product/new_product_screen.dart` | Formulário de novo produto, com leitura de código de barras via câmera (admin). |
| Entrada de estoque | `update_stock/update_stock_screen.dart` | Busca um produto e soma quantidade ao estoque. |
| Saída de estoque | `remove_product/remove_product_screen.dart` | Busca um produto e retira quantidade do estoque (`CollectProductScreen`). |
| Remover produtos | `delete_product/delete_product_screen.dart` | Exclusão definitiva de produtos (admin). |
| Leitor de código de barras | `barcode/barcode_screen.dart` | Câmera com `mobile_scanner` e overlay de mira customizado (`CustomPainter`). |
| Configurações | `settings/settings_screen.dart` | Alternância de tema e logout. |

Rotas nomeadas centralizadas em [`lib/presentation/routes/app_routes.dart`](lib/presentation/routes/app_routes.dart).

### `lib/core`
Constantes compartilhadas: `core_strings.dart` (textos em pt-BR), `core_fonts.dart` (estilos de
fonte, incluindo a fonte customizada RussoOne), `core_assets.dart` (caminhos de imagens),
`app_logger.dart` (logger global usado pelos Blocs) e `supabase_config.dart` (URL e chave pública
do projeto Supabase).

## Testes

- **Testes de widget** ([`test/widget_test.dart`](test/widget_test.dart)): fluxos ponta a ponta
  simulados com repositórios falsos (`test/helpers/fake_repositories.dart`) — adicionar produto,
  remover produto, coletar produto e listar produtos.
- **Testes de golden** ([`test/golden/`](test/golden)): comparam a renderização de cada tela
  (login, home, lista de produtos, entrada, coleta, exclusão) em modo claro e escuro contra imagens
  de referência em `test/golden/goldens/`.

Executar todos os testes:

```bash
flutter test
```

Atualizar as imagens de referência dos golden tests após uma mudança visual intencional:

```bash
flutter test --update-goldens
```

## Como rodar o projeto

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.1.0`).
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Configure o Supabase em [`lib/core/supabase_config.dart`](lib/core/supabase_config.dart) (URL e
   chave pública do seu projeto) e publique as Edge Functions esperadas pelo app:
   `auth-register`, `auth-profile`, `products-list`, `products-add`, `products-increase`,
   `products-decrease`, `products-delete`.
4. Rode o app em um dispositivo/emulador conectado:
   ```bash
   flutter run
   ```

## Estrutura de pastas (resumo)

```
storage_test/
├── android/ ios/ linux/ macos/ windows/ web/   # Projetos nativos por plataforma
├── assets/                                      # Imagens e fontes
├── lib/                                         # Código-fonte do app (ver seção Arquitetura)
├── test/                                        # Testes de widget e golden tests
└── pubspec.yaml                                 # Dependências e metadados do projeto
```
