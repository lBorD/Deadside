# AutoHotkey Tools - Site de Download

Um site moderno e responsivo para distribuição de ferramentas AutoHotkey com sistema de download funcional.

## 🚀 Características

- **Design Moderno**: Interface limpa e profissional com gradientes e efeitos visuais
- **Totalmente Responsivo**: Funciona perfeitamente em desktop, tablet e mobile
- **Sistema de Download**: Botões de download configuráveis para diferentes ferramentas
- **Animações Suaves**: Transições e animações CSS para melhor experiência do usuário
- **Navegação Intuitiva**: Menu de navegação com scroll suave
- **Modal de Versões**: Sistema para gerenciar múltiplas versões das ferramentas
- **Notificações**: Sistema de notificações em tempo real

## 📁 Estrutura dos Arquivos

```
site/
├── index.html          # Página principal
├── styles.css          # Estilos CSS
├── script.js           # JavaScript com funcionalidades
└── README.md           # Este arquivo
```

## ⚙️ Configuração dos Links de Download

Para configurar os links de download, edite o arquivo `script.js` e modifique o objeto `downloadLinks`:

```javascript
const downloadLinks = {
  // Link principal
  main: "https://seu-link-principal.com/download",

  // Links específicos para cada ferramenta
  deadsidetool: "https://seu-link-deadsidetool.com",
  famas4x: "https://seu-link-famas4x.com",

  // Links para versões específicas
  "deadside1.1.1": "https://seu-link-version-1.1.1.com",
  "deadside1.1": "https://seu-link-version-1.1.com",
  "deadside1.0.1": "https://seu-link-version-1.0.1.com",
  "deadside1.0": "https://seu-link-version-1.0.com",
};
```

### Método Alternativo de Configuração

Você também pode usar a função `configureDownloadLinks()` para atualizar os links dinamicamente:

```javascript
configureDownloadLinks({
  main: "https://novo-link-principal.com",
  deadsidetool: "https://novo-link-deadsidetool.com",
  // ... outros links
});
```

## 🎨 Personalização

### Cores e Tema

As cores principais podem ser alteradas no arquivo `styles.css`:

- **Cor primária**: `#ffd700` (dourado)
- **Gradiente de fundo**: `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
- **Cores de notificação**: Definidas no JavaScript

### Conteúdo

Para alterar o conteúdo do site, edite o arquivo `index.html`:

- Títulos e textos
- Descrições das ferramentas
- Informações da seção "Sobre"

## 📱 Responsividade

O site é totalmente responsivo e se adapta a diferentes tamanhos de tela:

- **Desktop**: Layout completo com grid de 2 colunas
- **Tablet**: Layout adaptado com elementos reorganizados
- **Mobile**: Layout em coluna única otimizado para toque

## 🔧 Funcionalidades JavaScript

### Principais Funções

- `downloadFile()`: Download do arquivo principal
- `downloadSpecific(tool)`: Download de ferramenta específica
- `downloadVersion(version)`: Download de versão específica
- `showVersions()`: Abre modal com versões disponíveis
- `showNotification(message, type)`: Exibe notificações

### Tipos de Notificação

- `success`: Download bem-sucedido
- `warning`: Aviso sobre link não configurado
- `error`: Erro no download
- `info`: Informação geral

## 🌐 Como Usar

1. **Configure os links**: Edite o arquivo `script.js` e defina os links de download
2. **Personalize o conteúdo**: Modifique textos e imagens no `index.html`
3. **Ajuste o design**: Altere cores e estilos no `styles.css`
4. **Teste localmente**: Abra o `index.html` em um navegador
5. **Faça upload**: Envie os arquivos para seu servidor web

## 📋 Requisitos

- Navegador moderno com suporte a:
  - CSS Grid e Flexbox
  - CSS Animations
  - Intersection Observer API
  - ES6+ JavaScript

## 🔗 Dependências Externas

- **Google Fonts**: Fonte Inter
- **Font Awesome**: Ícones
- **CDN**: Carregamento via CDN (sem instalação necessária)

## 🚀 Deploy

Para fazer o deploy do site:

1. **Hospedagem Local**: Simplesmente abra o `index.html` no navegador
2. **Servidor Web**: Faça upload dos arquivos para seu servidor
3. **GitHub Pages**: Push para um repositório GitHub e ative GitHub Pages
4. **Netlify/Vercel**: Conecte seu repositório para deploy automático

## 📞 Suporte

Para dúvidas ou problemas:

1. Verifique se todos os arquivos estão na mesma pasta
2. Confirme se os links de download estão configurados corretamente
3. Teste em diferentes navegadores
4. Verifique o console do navegador para erros JavaScript

## 📄 Licença

Este projeto é de uso livre. Sinta-se à vontade para modificar e distribuir conforme suas necessidades.
