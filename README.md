# Personal Neovim Configuration

## Background
처음에는 Neovim을 단순히 Vim의 대체품 정도로 생각했고 Windows 환경에서는 기본 GUI client가 부실해서 사용하지 않았다.
시간이 좀 지난 지금은 Neovim에 많은 기능이 추가되었고 또 매우 많은 plugin들이 개발되었다.
Neovim의 plugin은 처음에는 Vim script로 만들어진 기존 plugin을 많이 사용했으나 Lua 지원이 정착되면서 현재는 Lua로 작성된 멋진 plugin들이 많아졌다.

너무 많은 plugin들이 있기 때문에 고르기가 쉽지 않았다.
[awesome-neovim](https://github.com/rockerBOO/awesome-neovim)에 어느정도 추려진 목록이 있지만 그래도 많다.
그래서 [LazyVim](https://github.com/LazyVim/LazyVim)에서 사용하는 plugin들과 설정을 참고해서 개인 설정을 만들기로 했다.

Windows에서 GUI client를 사용하는 환경을 기준으로 한다. Neovim의 기본 GUI인 neovim-qt는 일부 plugin 동작이 제대로 되지 않았다. [Neovide](https://github.com/neovide/neovide)를 사용하기로 한다.

## Configuration Layout
LazyVim과 같이 많은 plugin과 custom설정을 관리하는 경우 여러 파일과 폴더로 config 파일을 구분하고 있다.
하지만 나는 그 정도로 복잡하게 관리하고 싶지 않기 때문에 [nvim-starter](https://github.com/VonHeikemen/nvim-starter)의 [02-opinionated](https://github.com/VonHeikemen/nvim-starter/tree/02-opinionated)와 같이 init.lua 파일 하나에서 모든 설정을 관리하려고 한다.

## Plugins
### Plugin Manager
기존에는 [vim-plug](https://github.com/junegunn/vim-plug)를 사용했지만 되도록Lua로 작성된 plugin들로
모두 바꿀 생각이므로 plugin manager도 Lua로 만들어진 것을 사용하기로 한다.
[savq/paq-nvim](https://github.com/savq/paq-nvim)이 별이 더 많지만 참고 대상인 LazyVim에서 lazy.nvim을 사용하고 있기 때문에 [folke/lazy.nvim](https://github.com/folke/lazy.nvim)으로 선택했다.
