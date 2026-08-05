%% labguide.cls
%% =====================================================================
%%  Classe LaTeX para guias de laboratório (Huawei Cloud)
%%  (Huawei Cloud). Requer XeLaTeX ou LuaLaTeX (por causa do fontspec).
%%
%%  Fontes usadas:
%%    - Texto  : Huawei Sans   (fallback: Liberation Sans / Arial)
%%    - Código : Consolas      (fallback: DejaVu Sans Mono)
%%
%%  Opções de classe:
%%    indentbody  -> recua todo o texto corrido em \contentindent,
%%                   (padrão: desligado).
%%    <qualquer>  -> repassada para a classe article.
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{labguide}[2025/07/20 Huawei Lab Guide template]

% ---- Opções --------------------------------------------------------
\newif\if@indentbody \@indentbodyfalse
\DeclareOption{indentbody}{\@indentbodytrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[a4paper,10pt]{article}

% ---- Pacotes -------------------------------------------------------
\RequirePackage[a4paper,top=3cm,bottom=3cm,left=2cm,right=2cm,%
                headheight=1.4cm,headsep=0.7cm]{geometry}
\RequirePackage{fontspec}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage[titles]{tocloft}
\RequirePackage{enumitem}
\RequirePackage{listings}
\RequirePackage[most]{tcolorbox}
\RequirePackage{ragged2e}
\RequirePackage{needspace}
\RequirePackage{babel}
\babelprovide[import,main]{brazilian}
\RequirePackage[hidelinks]{hyperref}

% =====================================================================
%  CORES
% =====================================================================
\definecolor{codebg}{HTML}{F6F8FA}   % fundo dos blocos de código
\definecolor{codetext}{HTML}{1F2328} % texto do código
\definecolor{linkblue}{HTML}{0000FF} % hyperlinks (sem sublinhado)
\definecolor{huaweired}{HTML}{C7000B}% vermelho da marca (acentos)
\definecolor{ruleblack}{HTML}{000000} % cor das regras horizontais (preto)

% =====================================================================
%  FONTES  (com fallback automático se as proprietárias faltarem)
% =====================================================================
\newcommand{\lg@warnfont}[2]{%
  \ClassWarning{labguide}{Fonte "#1" nao encontrada; usando fallback "#2".
    Instale a fonte para fidelidade total.}}

\IfFontExistsTF{Huawei Sans}
  {\setmainfont{Huawei Sans}}
  {\lg@warnfont{Huawei Sans}{Liberation Sans}%
   \IfFontExistsTF{Liberation Sans}
     {\setmainfont{Liberation Sans}}
     {\setmainfont{Arial}}}

\IfFontExistsTF{Consolas}
  {\newfontfamily\consolasfont{Consolas}}
  {\lg@warnfont{Consolas}{DejaVu Sans Mono}%
   \newfontfamily\consolasfont{DejaVu Sans Mono}}
\newcommand{\codefont}{\consolasfont}

% Tamanho base do corpo: 10.5pt com entrelinha ~14pt
\renewcommand\normalsize{\@setfontsize\normalsize{10.5}{14}}
\normalsize
\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt}      % espaçamento entre parágrafos
\frenchspacing                % sem espaço extra após ponto final

% Recuo opcional do corpo (opção [indentbody])
\newlength{\contentindent}\setlength{\contentindent}{0.6cm}
\if@indentbody
  \AtBeginDocument{\setlength{\leftskip}{\contentindent}}
\fi

% =====================================================================
%  HYPERREF  (links azuis, sem sublinhado)
% =====================================================================
\hypersetup{
  colorlinks=true,
  linkcolor=black,      % links internos (TOC) em preto
  urlcolor=linkblue,
  citecolor=linkblue,
  linktoc=all,
  bookmarksnumbered=true,
}
% \href e \url ficam azuis; para link textual azul use \weblink

% =====================================================================
%  CABEÇALHO E RODAPÉ
% =====================================================================
% Texto central do cabeçalho (configurável): \setheadertitle{...}
\newcommand{\lg@headertitle}{Huawei Cloud}
\newcommand{\setheadertitle}[1]{\renewcommand{\lg@headertitle}{#1}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% Coluna esquerda: logo | centro: título | direita: "Página N"
\fancyhead[L]{\raisebox{-0.35cm}[0pt][0pt]{%
    \includegraphics[height=1.05cm]{assets/huawei-logo-header.png}}}
\fancyhead[C]{\normalfont\fontsize{10}{12}\selectfont \lg@headertitle}
\fancyhead[R]{\normalfont\fontsize{10}{12}\selectfont Página~\thepage}

% =====================================================================
%  TÍTULOS (headings)
% =====================================================================
\setcounter{secnumdepth}{4}

% --- H1: número gigante (72pt) + título 22pt bold à direita + regra
\titleformat{\section}
  {\normalfont\bfseries\fontsize{22}{26}\selectfont}
  {\makebox[0pt][l]{\fontsize{72}{72}\selectfont\thesection}}
  {0pt}
  {\raggedleft\hspace*{1.6cm}}          % empurra o título p/ direita
  [\vspace{2pt}{\color{huaweired}\titlerule[1.5pt]}\vspace{18pt}]
\titlespacing*{\section}{0pt}{0pt}{40pt} % antes 0 / depois 40pt
% Cada \section (capítulo) começa em uma nova página
\let\lg@origsection\section
\renewcommand{\section}{\clearpage\lg@origsection}

% --- H2/H3/H4: regular, tamanhos decrescentes, alinhados à esquerda
\titleformat{\subsection}
  {\normalfont\fontsize{18}{22}\selectfont}{\thesubsection}{0.4em}{}
\titlespacing*{\subsection}{0pt}{30pt}{6pt}

\titleformat{\subsubsection}
  {\normalfont\fontsize{16}{20}\selectfont}{\thesubsubsection}{0.4em}{}
\titlespacing*{\subsubsection}{0pt}{10pt}{4pt}

\titleformat{\paragraph}[hang]
  {\normalfont\fontsize{14}{18}\selectfont}{\theparagraph}{0.4em}{}
\titlespacing*{\paragraph}{0pt}{8pt}{4pt}

% Numeração: 1  /  1.1  /  1.1.1  /  1.1.1.1
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}
\renewcommand{\theparagraph}{\thesubsubsection.\arabic{paragraph}}

% =====================================================================
%  SUMÁRIO (TOC) — título "Sumário" à direita + regra; leaders pontilhados
% =====================================================================
\renewcommand{\contentsname}{Sumário}
\renewcommand{\cfttoctitlefont}{\hfill\normalfont\bfseries\fontsize{22}{26}\selectfont}
\renewcommand{\cftaftertoctitle}{\par\vspace{2pt}%
  {\color{ruleblack}\hrule height 0.5pt}\vspace{6pt}}
% Nível 1: negrito 12pt
\renewcommand{\cftsecfont}{\bfseries\fontsize{12}{15}\selectfont}
\renewcommand{\cftsecpagefont}{\bfseries\fontsize{12}{15}\selectfont}
\renewcommand{\cftsecleader}{\bfseries\cftdotfill{\cftdotsep}}
% Níveis 2 e 3: normal 10pt
\renewcommand{\cftsubsecfont}{\fontsize{10}{13}\selectfont}
\renewcommand{\cftsubsecpagefont}{\fontsize{10}{13}\selectfont}
\renewcommand{\cftsubsubsecfont}{\fontsize{10}{13}\selectfont}
\renewcommand{\cftsubsubsecpagefont}{\fontsize{10}{13}\selectfont}
% Recuos do TOC começando na margem (ind left=0)
\setlength{\cftsecindent}{0pt}
\setlength{\cftsubsecindent}{1.2em}
\setlength{\cftsubsubsecindent}{2.4em}
\setlength{\cftbeforesecskip}{4pt}
\renewcommand{\cftdotsep}{1.2}
% mostra pontilhado também no nível 1
\setcounter{tocdepth}{3}

% Comando de conveniência para o sumário (reseta leftskip)
\newcommand{\sumario}{{\leftskip=0pt\relax\tableofcontents}\clearpage}

% =====================================================================
%  CAPA
% =====================================================================
% \setlabtitle{...}  -> título grande da capa (e default do header)
\newcommand{\lg@labtitle}{Guia de Laboratório}
\newcommand{\setlabtitle}[1]{\renewcommand{\lg@labtitle}{#1}}
\newcommand{\lg@covertext}{Huawei Technologies CO., LTD}
\newcommand{\setcovertext}[1]{\renewcommand{\lg@covertext}{#1}}

\newcommand{\makecover}{%
  \begingroup
  \leftskip=0pt\relax
  \thispagestyle{fancy}%
  \vspace*{2.2cm}%
  {\centering
   \fontsize{36}{42}\selectfont \lg@labtitle\par}%
  \vspace{4.5cm}%
  {\centering
   \includegraphics[width=3.6cm]{assets/huawei-logo-cover.png}\par}%
  \vspace{0.9cm}%
  {\centering
   \fontsize{16}{20}\selectfont \lg@covertext\par}%
  \endgroup
  \clearpage}

% =====================================================================
%  CORPO — reinicia numeração de páginas
% =====================================================================
\newcommand{\startbody}{\clearpage\setcounter{page}{1}}

% =====================================================================
%  BLOCO DE OBJETIVOS / PRÉ-REQUISITOS  (encerrado por regra 1.5pt)
% =====================================================================
% Uso:
%   \begin{objetivos}
%     \objgeral{...}
%     \prerequisitos
%       \item ...
%   \end{objetivos}
\newcommand{\lg@rotulo}[1]{\textbf{#1}}
\newcommand{\objgeral}[1]{\par\lg@rotulo{Objetivo Geral:} #1\par}
\newcommand{\objpratica}[1]{\par\lg@rotulo{Objetivo da prática:} #1\par}
\newcommand{\passoapasso}{\par\lg@rotulo{Passo a passo:}\par}
\newcommand{\prerequisitos}{\par\lg@rotulo{Pré-requisitos:}\par}

\newenvironment{objetivos}
  {\par\medskip}
  {\par\vspace{4pt}%
   {\leftskip=0pt\relax\noindent{\color{ruleblack}\rule{\linewidth}{1.5pt}}}%
   \par\vspace{10pt}}

% =====================================================================
%  LISTAS  (bullets e numeradas, no estilo do documento)
% =====================================================================
\setlist[itemize]{leftmargin=1.6em,topsep=2pt,itemsep=2pt,parsep=0pt}
\setlist[enumerate]{leftmargin=1.8em,topsep=2pt,itemsep=2pt,parsep=0pt}

% =====================================================================
%  CÓDIGO
% =====================================================================
\lstdefinestyle{lgcode}{
  basicstyle=\codefont\fontsize{10}{13}\selectfont\color{codetext},
  breaklines=true,
  breakatwhitespace=false,
  columns=fullflexible,
  keepspaces=true,
  showstringspaces=false,
  tabsize=2,
  upquote=true,
}

% Bloco de código: fundo #F6F8FA, sem borda, recuo à esquerda
\newtcblisting{codigo}[1][]{
  listing only,
  listing style=lgcode,
  listing options={language=#1},
  colback=codebg, colframe=codebg,
  boxrule=0pt, arc=0pt, outer arc=0pt,
  left=8pt, right=8pt, top=6pt, bottom=6pt,
  before skip=6pt, after skip=6pt,
  breakable,
  enhanced jigsaw,
  left skip=0.7cm,   % recuo do bloco (0,7 cm a partir da margem)
}

% Bloco de código a partir de arquivo externo
\newcommand{\codigoarquivo}[2][]{%
  \begin{tcolorbox}[listing only,listing style=lgcode,
      listing options={language=#1},
      colback=codebg,colframe=codebg,boxrule=0pt,arc=0pt,outer arc=0pt,
      left=8pt,right=8pt,top=6pt,bottom=6pt,breakable,left skip=0.7cm]
    \lstinputlisting[style=lgcode]{#2}
  \end{tcolorbox}}

% Código inline: \code{...}
\newcommand{\code}[1]{{\codefont\fontsize{10}{12}\selectfont\color{codetext}#1}}
% Parâmetro/arquivo citado no texto (itálico)
\newcommand{\param}[1]{\textit{#1}}

% =====================================================================
%  IMAGENS  — sempre centralizadas horizontalmente
% =====================================================================
% \imagem[largura]{arquivo}   (sem legenda)
\newcommand{\imagem}[2][0.85\linewidth]{%
  \par\medskip
  {\leftskip=0pt\rightskip=0pt\parindent=0pt\centering
   \includegraphics[width=#1]{#2}\par}%
  \medskip}

% \imagemc[largura]{arquivo}{legenda}  (com legenda centralizada)
\newcommand{\imagemc}[3][0.85\linewidth]{%
  \par\medskip
  {\leftskip=0pt\rightskip=0pt\parindent=0pt\centering
   \includegraphics[width=#1]{#2}\par
   \vspace{2pt}\footnotesize #3\par}%
  \medskip}

% =====================================================================
%  NOTA / OBSERVAÇÃO  (texto em itálico)
% =====================================================================
\newcommand{\nota}[1]{\par\medskip\textit{#1}\par\medskip}

% Link textual azul (sem sublinhado), preservando destino clicável
\newcommand{\weblink}[2]{\href{#1}{\textcolor{linkblue}{#2}}}

\endinput
