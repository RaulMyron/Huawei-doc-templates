%% guide.cls
%% =====================================================================
%%  Classe LaTeX para guias (Huawei Cloud)
%%  Requer XeLaTeX ou LuaLaTeX (por causa do fontspec).
%%
%%  Fontes usadas:
%%    - Texto : HarmonyOS Sans (fallback: Liberation Sans / Arial)
%%    - Código : Cascadia Code (fallback: Consolas / DejaVu Sans Mono)
%%
%%  Opções de classe:
%%    english     -> usa inglês nos rótulos predefinidos e no babel.
%%                   (padrão: português brasileiro).
%%    indentbody  -> recua todo o texto corrido em \contentindent,
%%                   (padrão: desligado).
%%    notime      -> oculta a hora de compilação na capa.
%%                   (padrão: mostra hora).
%%    <qualquer>  -> repassada para a classe article.
%% =====================================================================
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{guide}[2025/07/20 Huawei Guide template]

% ---- Opções --------------------------------------------------------
\newif\if@indentbody \@indentbodyfalse
\DeclareOption{indentbody}{\@indentbodytrue}
\newif\if@english \@englishfalse
\DeclareOption{english}{\@englishtrue}
\newif\if@showtime \@showtimetrue
\DeclareOption{notime}{\@showtimefalse}
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
\RequirePackage{fancyvrb}
\RequirePackage{fvextra}
\RequirePackage[most]{tcolorbox}
\RequirePackage{ragged2e}
\RequirePackage{needspace}
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{babel}
\if@english
  \babelprovide[import,main]{english}
\else
  \babelprovide[import,main]{brazilian}
\fi
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{caption}
\captionsetup[figure]{font={small}, labelfont=bf, labelsep=colon}
\captionsetup[table]{font={small}, labelfont=bf, labelsep=colon}

% =====================================================================
%  CORES
% =====================================================================
\definecolor{codebg}{HTML}{F6F8FA}   % fundo dos blocos de código
\definecolor{codetext}{HTML}{1F2328} % texto do código
\definecolor{linkblue}{HTML}{0000FF} % hyperlinks (sem sublinhado)
\definecolor{huaweired}{HTML}{C7000B}% vermelho da marca (acentos)
\definecolor{ruleblack}{HTML}{000000} % cor das regras horizontais (preto)
\definecolor{warningbg}{HTML}{FFF8E1} % fundo dos avisos (âmbar claro)
\definecolor{warningfg}{HTML}{F57C00} % borda dos avisos (âmbar)
\definecolor{tipbg}{HTML}{E8F5E9}     % fundo das dicas (verde claro)
\definecolor{tipfg}{HTML}{2E7D32}     % borda das dicas (verde)
\definecolor{infobg}{HTML}{E3F2FD}    % fundo das infos (azul claro)
\definecolor{infofg}{HTML}{1565C0}    % borda das infos (azul)

% =====================================================================
%  FONTES  (com fallback automático se as proprietárias faltarem)
% =====================================================================
\newcommand{\lg@warnfont}[2]{%
  \ClassWarning{guide}{Font "#1" not found; using fallback "#2".
    Install the font for full fidelity.}}

\IfFontExistsTF{HarmonyOS Sans}
  {\setmainfont{HarmonyOS Sans}}
   {\lg@warnfont{HarmonyOS Sans}{Liberation Sans}%
    \IfFontExistsTF{Liberation Sans}
      {\setmainfont{Liberation Sans}}
      {\IfFontExistsTF{Arial}
        {\setmainfont{Arial}}
         {\lg@warnfont{Arial}{fontspec default}}}}

\IfFontExistsTF{Cascadia Code}
  {\newfontfamily\consolasfont{Cascadia Code}[Ligatures=NoCommon]}
  {\lg@warnfont{Cascadia Code}{Consolas}%
   \IfFontExistsTF{Consolas}
     {\newfontfamily\consolasfont{Consolas}[Ligatures=NoCommon]}
     {\lg@warnfont{Consolas}{DejaVu Sans Mono}%
      \newfontfamily\consolasfont{DejaVu Sans Mono}[Ligatures=NoCommon]}}
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
%  IDIOMA  (rótulos predefinidos conforme a opção [english])
% =====================================================================
\if@english
  \newcommand{\lg@sumario}{Contents}
  \newcommand{\lg@objgerallabel}{General Objective:}
  \newcommand{\lg@objpraticalabel}{Objective:}
  \newcommand{\lg@prerequisitoslabel}{Prerequisites:}
  \newcommand{\lg@passoapassolabel}{Step by step:}
  \newcommand{\lg@paginalabel}{Page}
\else
  \newcommand{\lg@sumario}{Sumário}
  \newcommand{\lg@objgerallabel}{Objetivo Geral:}
  \newcommand{\lg@objpraticalabel}{Objetivo:}
  \newcommand{\lg@prerequisitoslabel}{Pré-requisitos:}
  \newcommand{\lg@passoapassolabel}{Passo a passo:}
  \newcommand{\lg@paginalabel}{Página}
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
\newcommand{\lg@headerlogo}{assets/huawei-logo-header.png}
\newcommand{\setheaderlogo}[1]{\renewcommand{\lg@headerlogo}{#1}}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% Header: logo (left) + title (center)
% Footer: "Página N" (center)
\fancyhead[L]{\raisebox{-0.35cm}[0pt][0pt]{%
    \includegraphics[height=1.05cm]{\lg@headerlogo}}}
\fancyhead[C]{\normalfont\fontsize{10}{12}\selectfont \lg@headertitle}
\fancyfoot[C]{\normalfont\fontsize{10}{12}\selectfont \lg@paginalabel~\thepage}

% Plain style: no header, page number in footer (for TOC, changelog)
\fancypagestyle{plain}{
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyfoot[C]{\normalfont\fontsize{10}{12}\selectfont \lg@paginalabel~\thepage}
}

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
\renewcommand{\contentsname}{\lg@sumario}
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
\newcommand{\sumario}{{\leftskip=0pt\relax\pagestyle{plain}\thispagestyle{plain}\tableofcontents}\clearpage}

% =====================================================================
%  CAPA
% =====================================================================
% \setguidetitle{...}  -> título grande da capa (e default do header)
\if@english
  \newcommand{\lg@guidetitle}{Guide}
\else
  \newcommand{\lg@guidetitle}{Guia}
\fi
\newcommand{\setguidetitle}[1]{\renewcommand{\lg@guidetitle}{#1}}
\newcommand{\lg@covertext}{Huawei Technologies CO., LTD}
\newcommand{\setcovertext}[1]{\renewcommand{\lg@covertext}{#1}}
\newcommand{\lg@coverlogo}{assets/huawei-logo-cover.png}
\newcommand{\setcoverlogo}[1]{\renewcommand{\lg@coverlogo}{#1}}
\newcommand{\lg@docversion}{}
\newcommand{\setdocversion}[1]{\renewcommand{\lg@docversion}{#1}}
\newcommand{\lg@docdate}{\today}
\newcommand{\setdocdate}[1]{\renewcommand{\lg@docdate}{#1}}
% Compilation time from \time primitive (minutes since midnight, respects TZ)
\newcount\lg@hour
\newcount\lg@min
\newcount\lg@tmp
\lg@hour=\time
\divide\lg@hour by 60
\lg@tmp=\lg@hour
\multiply\lg@tmp by 60
\lg@min=\time
\advance\lg@min by -\lg@tmp
\newcommand{\lg@covermeta}{%
  \ifx\lg@docversion\@empty\else\textbf{v\lg@docversion}\fi
  \ifx\lg@docversion\@empty\else\ifx\lg@docdate\@empty\else\ — \fi\fi
  \ifx\lg@docdate\@empty\else\lg@docdate\fi
  \if@showtime\ \two@digits{\lg@hour}:\two@digits{\lg@min}\fi%
}

\newcommand{\makecover}{%
  \begingroup
  \leftskip=0pt\relax
  \thispagestyle{empty}%
  \vspace*{2.2cm}%
  {\centering
   \fontsize{36}{42}\selectfont\bfseries \lg@guidetitle\par}%
  \vspace{4.5cm}%
  {\centering
   \includegraphics[width=3.6cm]{\lg@coverlogo}\par}%
  \vspace{0.9cm}%
   {\centering
    \fontsize{16}{20}\selectfont \lg@covertext\par}%
   \vspace{0.5cm}%
   {\centering
    \fontsize{12}{14}\selectfont \lg@covermeta\par}%
   \endgroup
  \clearpage}

% =====================================================================
%  CORPO — reinicia numeração de páginas
% =====================================================================
\newcommand{\startbody}{\clearpage\pagestyle{fancy}\thispagestyle{fancy}\setcounter{page}{1}}

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
\newcommand{\objgeral}[1]{\par\lg@rotulo{\lg@objgerallabel} #1\par}
\newcommand{\objpratica}[1]{\par\lg@rotulo{\lg@objpraticalabel} #1\par}
\newcommand{\passoapasso}{\par\lg@rotulo{\lg@passoapassolabel}\par}
\newcommand{\prerequisitos}{\par\lg@rotulo{\lg@prerequisitoslabel}\par}

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
%  CÓDIGO  (fancyvrb + fvextra — clean PDF copy-paste)
% =====================================================================
% No-op keys for language hints ([bash], [python], etc.) — ignored,
% kept for backward compatibility with existing documents.
\define@key{FV}{bash}[unused]{}
\define@key{FV}{sh}[unused]{}
\define@key{FV}{shell}[unused]{}
\define@key{FV}{python}[unused]{}
\define@key{FV}{Python}[unused]{}
\define@key{FV}{json}[unused]{}
\define@key{FV}{yaml}[unused]{}
\define@key{FV}{xml}[unused]{}
\define@key{FV}{html}[unused]{}
\define@key{FV}{javascript}[unused]{}
\define@key{FV}{js}[unused]{}
\define@key{FV}{sql}[unused]{}
\define@key{FV}{text}[unused]{}
\define@key{FV}{ini}[unused]{}
\define@key{FV}{conf}[unused]{}

% Bloco de código: fundo #F6F8FA, sem borda, recuo à esquerda
% Usa fancyvrb (não listings) para copy-paste limpo no PDF.
% listings processa caractere por caractere → xdvipdfmx escreve cada
% um como operação de texto separada → leitores de PDF inserem espaços.
% fancyvrb typeseta linha por linha → texto contíguo no PDF → copy limpo.
\DefineVerbatimEnvironment{codigo}{Verbatim}
{fontsize=\fontsize{10}{13}\selectfont, formatcom=\codefont\color{codetext},
 frame=none,
 backgroundcolor=codebg,
 xleftmargin=0.7cm, xrightmargin=0.5cm,
 breaklines=true, breakanywhere=true,
 breaksymbolleft={}, breaksymbolright={},
 breakanywheresymbolpre={}, breakanywheresymbolpost={},
}

% Bloco de código a partir de arquivo externo
\newcommand{\codigoarquivo}[2][]{%
  \VerbatimInput[fontsize=\fontsize{10}{13}\selectfont,
   formatcom=\codefont\color{codetext},
   frame=none,
   backgroundcolor=codebg,
   xleftmargin=0.7cm, xrightmargin=0.5cm,
   breaklines=true, breakanywhere=true,
   breaksymbolleft={}, breaksymbolright={},
   breakanywheresymbolpre={}, breakanywheresymbolpost={}]{#2}%
}

% Código inline: \code{...}
\newcommand{\code}[1]{{\codefont\fontsize{10}{12}\selectfont\color{codetext}#1}}
% Parâmetro/arquivo citado no texto (itálico)
\newcommand{\param}[1]{\textit{#1}}

% =====================================================================
%  IMAGENS  — sempre centralizadas horizontalmente
% =====================================================================
% \imagem[largura]{arquivo}   (sem legenda)
% Limita por largura E altura, mantendo proporção (keepaspectratio).
% Imagens horizontais: limitadas pela largura (0.65\linewidth).
% Imagens verticais: limitadas pela altura (0.4\textheight).
\newcommand{\imagem}[2][0.65\linewidth]{%
  \par\medskip
  {\leftskip=0pt\rightskip=0pt\parindent=0pt\centering
   \includegraphics[width=#1,height=0.4\textheight,keepaspectratio]{#2}\par}%
  \medskip}

% \imagemc[largura]{arquivo}{legenda}  (com legenda numerada — Figura N)
\newcommand{\imagemc}[3][0.65\linewidth]{%
  \par\medskip
  {\leftskip=0pt\rightskip=0pt\parindent=0pt\centering
   \includegraphics[width=#1,height=0.4\textheight,keepaspectratio]{#2}\par
   \vspace{2pt}\captionof{figure}{#3}\par}%
  \medskip}

% \imagemplaceholder{caminho}{descrição}
% Mostra um box tracejado indicando onde o usuário deve colocar a imagem.
% O usuário adiciona o arquivo manualmente no caminho indicado.
\newcommand{\imagemplaceholder}[2]{%
  \par\medskip
  \begin{tcolorbox}[
    colback=codebg, colframe=warningfg,
    boxrule=1pt, arc=4pt, outer arc=4pt,
    left=12pt, right=12pt, top=10pt, bottom=10pt,
    before skip=8pt, after skip=8pt,
    breakable, enhanced jigsaw]
    \centering
    {\codefont\color{codetext}\fontsize{11}{13}\selectfont
     [ Image placeholder ]}\\[6pt]
    {\footnotesize\color{codetext}
     \textbf{File:} \code{#1}}\\[4pt]
    {\footnotesize\color{codetext}
     \textbf{Description:} #2}\\[6pt]
    {\footnotesize\itshape\color{warningfg}
     Place the image file at the path above, then replace this command with
     \code{\textbackslash imagem\{#1\}} or
     \code{\textbackslash imagemc\{#1\}\{caption\}}.}
  \end{tcolorbox}
  \par\medskip}

% =====================================================================
%  NOTA / OBSERVAÇÃO  (texto em itálico)
% =====================================================================
\newcommand{\nota}[1]{\par\medskip\textit{#1}\par\medskip}

% Link textual azul (sem sublinhado), preservando destino clicável
\newcommand{\weblink}[2]{\href{#1}{\textcolor{linkblue}{#2}}}

% =====================================================================
%  CAIXAS DE AVISO  (callout boxes: aviso, dica, info)
% =====================================================================
% Uso:
%   \begin{aviso} ... \end{aviso}   — atenção / cuidado (âmbar)
%   \begin{dica}  ... \end{dica}    — sugestão / dica (verde)
%   \begin{infobox}  ... \end{infobox}  — informação adicional (azul)
\newcommand{\lg@callout}[3]{%
  \newtcolorbox{#1}{colback=#2, colframe=#3,
    boxrule=0pt, leftrule=3pt, arc=0pt, outer arc=0pt,
    left=8pt, right=8pt, top=6pt, bottom=6pt,
    before skip=6pt, after skip=6pt, breakable, enhanced jigsaw}}
\lg@callout{aviso}{warningbg}{warningfg}
\lg@callout{dica}{tipbg}{tipfg}
\lg@callout{infobox}{infobg}{infofg}

% =====================================================================
%  ETIQUETA / BADGE  (rótulo colorido inline)
% =====================================================================
% Uso: \badge{Novo}  -> rótulo vermelho com texto branco
\newcommand{\badge}[1]{%
  \colorbox{huaweired}{\textcolor{white}{\footnotesize\bfseries\strut~#1~}}}

% =====================================================================
%  CHANGELOG / VERSIONAMENTO
% =====================================================================
% Uso:
%   \setdocversion{1.0.0}       % mostra "v1.0.0" na capa
%   \setdocdate{2026-08-05}     % opcional; padrão = \today
%
%   \begin{changelog}
%     \changelogentry{1.0.0}{2026-08-05}{
%       \item Initial version
%       \item Added ECS provisioning
%     }
%     \changelogentry{0.9.0}{2025-07-15}{
%       \item Draft
%     }
%   \end{changelog}
\newenvironment{changelog}{%
  \par\medskip
  \thispagestyle{plain}\pagestyle{plain}%
  \noindent{\color{ruleblack}\rule{\linewidth}{0.5pt}}\par
  \vspace{6pt}
}{%
  \par\medskip
  \noindent{\color{ruleblack}\rule{\linewidth}{0.5pt}}\par
  \medskip
  \pagestyle{fancy}%
}
\newcommand{\changelogentry}[3]{%
  \par\smallskip
  \noindent\textbf{#1}\hfill\textit{#2}\par\nobreak\vspace{2pt}
  \begingroup\leftskip=1.2cm\relax
  \begin{itemize}[leftmargin=1.2em,topsep=0pt,itemsep=1pt,parsep=0pt]
    #3
  \end{itemize}
  \endgroup
}

\endinput
