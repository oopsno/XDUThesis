\NeedsTeXFormat{LaTeX2e}

% LaTeX3
\RequirePackage{expl3}
\RequirePackage{fancyhdr}
\RequirePackage{XDUThesis/common/switch}
\RequirePackage{XDUThesis/common/term}
\RequirePackage{XDUThesis/bachelor/cover}
\ProvidesExplClass{XDUThesis/bachelor}{2016/05/21}{0.1.0}{XDUThesis/bachelor}

% CTeX v2.3
\LoadClass[
  a4paper,
  hyperref,
  zihao      = -4,    % 默认小四号字体
  linespread = 1.5    % 近似1.5倍行距
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
        pagestyle  = XDUThesis::Bachelor::PageStyle,
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

% 定义页面样式
\fancypagestyle { XDUThesis::Bachelor::PageStyle } {
  % 清空页眉页脚
  \fancyhead { }
  \fancyfoot { }
  % 左(偶数)页面为论文题目
  \fancyhead [ CE ] { \textnormal { \songti\zihao{5}\thesis_info:n { title } } }
  % 右(奇数)页面为章次和章的标题
  \fancyhead [ CO ] { \textnormal { \songti\zihao{5}\leftmark } }
  % 页码宋体小五号, 排在页眉最外侧, 不加任何修饰
  \fancyhead [ LE, RO ] { \songti\zihao{-5}\thepage }
  % 页眉底划线的宽度为0.75磅
  \renewcommand{\headrulewidth}{0.75pt}
}

% 并将上述样式置为默认值
\pagestyle { XDUThesis::Bachelor::PageStyle }

% 设置参考文献样式为GB/T 7714-2005
\bibliographystyle { XDUThesis/3rdparty/gbt7714/gbt7714-2005 }

\let \l__original_cite \cite
\RenewDocumentCommand \cite { m }
{
  $^\textnormal { \l__original_cite { #1 } }$
}

% 定义开关
\switch_group_new:nn { compile }           { 编译选项 }
\switch_new:nnn      { compile } { debug } { 调试模式 }
\switch_new:nnn      { compile } { SHTF  } { 盲审模式 }

% 标题设置
\NewDocumentCommand \SetCompileOptions { m }
  {
    \switch_group_set:nn { compile } { #1 }
  }

% 导出用于标题信息设置宏
\NewDocumentCommand   \SetCoverItems { m }
  {
    \cover_set:n { #1 }
  }
% 重定义maketitle
\RenewDocumentCommand \maketitle { m }
  {
    \cover_make:
  }

% SetTerm宏设置一个术语缩写, 例如使用
% \SetTerm{Abbr}{Abbreviation}{缩写}
% 将第定义宏\Abbr
% 首次引用时展开成 缩写(Abbreviation, Abbr)
% 其后引用时展开成 Abbr
\NewDocumentCommand \SetTerm { mmm }
  {
    \term_new:nnn { #1 } { #2 } { #3 }
  }

% DebugChapter宏在调用位置插入章节 ``调试信息''
\NewDocumentCommand \DebugChapter { }
  {
    \switch_if:nnTF { compile } { debug }
      {
        \msg_term:n { 正在以调试模式编译 }
        \chapter { 调试信息 }
        \switch_debuginfo:
        \cover_debuginfo:
      }
      {
      }
  }
