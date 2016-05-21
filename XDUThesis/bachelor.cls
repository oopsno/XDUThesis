\NeedsTeXFormat{LaTeX2e}

% LaTeX3
\RequirePackage{expl3}
\RequirePackage{switch}
\RequirePackage{cover}
\RequirePackage{autoterm}
\RequirePackage{fancyhdr}
\input{yabasky.cfg}
\ProvidesExplClass{yabasky}{2016/05/21}{0.1.0}{YaBAskY Document Class}

% CTeX v2.3
\LoadClass[
  a4paper,
  hyperref,
  zihao      = -4,    % 默认小四号字体
  linespread = 1.5,   % 近似1.5倍行距
  fontset    = adobe  % 默认Adobe字体集
]{ctexbook}[2016/02/02]

% 纸张设置
\RequirePackage[
  top        = 3cm,
  headheight = 2cm,
  headsep    = 1cm,  % 页眉 2cm 即页眉距上边界 1cm
  bottom     = 2cm,
  inner      = 4cm,  % 内页边距 3cm + 装订线 1cm
  outer      = 2cm
]{geometry}

% 图注设置
\RequirePackage[
  font     = small, % CTeX的主字体为小四号时 small 即五号
  labelsep = space
]{caption}

% 章节格式
\ctexset
  {
    chapter =
      {
        pagestyle  = YaBAskY::PageStyle,
        beforeskip = 1.2em,
        afterskip  = 1.2em,
        format = \centering\heiti\zihao{3}\bf,
      },
    section =
      {
        beforeskip = 1em,
        afterskip  = 1em,
        number = \thesection,
        format = \centering\songti\zihao{4}
      },
    subsection =
      {
        beforeskip = 1em,
        afterskip  = 1em,
        number = \thesubsection,
        format = \songti\zihao{4}
      },
    subsubsection =
      {
        beforeskip = 1em,
        afterskip  = 1em,
        number = \thesubsubsection,
        format = \songti\zihao{4}
      }
  }

% 西文字体默认使用Times
\fontfamily { ptm }

\fancypagestyle { YaBAskY::PageStyle } {
  \fancyhead { }
  \fancyfoot { }
  % 左(偶数)页面为论文题目
  \fancyhead [ CE ] { \textnormal { \songti\zihao{5}\thesis_info:n { title } } }
  % 页眉底划线的宽度为0.75磅
  \renewcommand{\headrulewidth}{0.75pt}
  % 右(奇数)页面为章次和章的标题
  \fancyhead [ CO ] { \textnormal { \songti\zihao{5}\leftmark } }
  % 页码宋体小五号 排在页眉最外侧 不加任何修饰
  \fancyhead [ LE, RO ] { \songti\zihao{-5}\thepage }
}

\pagestyle { YaBAskY::PageStyle }

% 定义开关
\switch_group_new:nn { compile }           { 编译选项 }
\switch_new:nnn      { compile } { debug } { 调试模式 }
\switch_new:nnn      { compile } { SHTF  } { 盲审模式 }

% 标题设置
\NewDocumentCommand \SetCompileOptions { m }
  { \switch_group_set:nn { compile } { #1 } }

\NewDocumentCommand \SetCoverItems { m }
  { \cover_set:n { #1 } }

\RenewDocumentCommand \maketitle { }
  { \cover_make: }

% 术语定义
\NewDocumentCommand \SetTerm { mmm }
  {
    \new_term:nnn { #1 } { #2 } { #3 }
  }

% 打印调试信息
\NewDocumentCommand \MakeDebugPage { }
  {
    \switch_if:nnTF { compile } { debug }
      {
        \msg_term:n { 正在以调试模式编译 }
        \chapter { 调试信息 }
        \switch_debuginfo:
        \cover_debuginfo:
      }
      {
        \msg_term:n { 正在以发布模式编译 }
      }
  }
