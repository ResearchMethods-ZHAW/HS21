\name{NEWS}
\title{PMCMR News}
\encoding{UTF-8}

\section{CHANGES IN PMCMR VERSION 4.1}{
  \subsection{MODIFICATIONS}{
    \itemize{
      \item In \code{posthoc.kruskal.nemenyi.test} and
      \code{posthoc.friedman.nemenyi.test} the df was set from 1000000
      to Inf for calculating p-values of Tukey's distribution.

      \item The vignette was checked for Typos and modified.

      \item The reported chi-square statistics in
      \code{posthoc.kruskal.nemenyi.test} are now corrected for ties.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 4.0}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item The function \code{get.pvalues} was included to extract the
      p-values from a \code{PMCMR} object or a
      \code{pairwise.htest} object.It can be further processed with
      \code{multcompLetters} from the package \code{multcompView} to
      find and indicate homogeneous groups for a given level of
      significance.
      
      \item The functions \code{durbin.test} and
      \code{posthoc.durbin.test} were added 
      to test wether k treatments in a two-way balanced incomplete
      block design have identical effects.
      
      \item The function \code{posthoc.quade.test} was added for
      multiple pairwise comparisons of rank sums for
      unreplicated blocked data.

      \item The Jonckheere-Terpstrata test, \code{jonckheere.test}, 
      was added as an omnibus test for testing k independent samples
      against ordered alternatives.

      \item A \code{print.PMCMR} and \code{summary.PMCMR} was added.
       
      \item The keyword \code{nonparametric} was
      inserted into each .Rd file.
    }
  }
   \subsection{BUGFIXES}{
    \itemize{
      \item Title in \code{.Rd}-file of \code{vanWaerden.test} was
      changed into van der Waerden's normal scores test.

      \item The formula method for \code{posthoc.friedman.conover.test}
      was disabled, because it does not work.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 3.0}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item The van der Waerden normal scores test, \code{vanWaerden.test}, 
      as an omnibus test for testing k independent samples for
      homogeneity was added to the package.
      
      \item The post-hoc test of van der Waerden,
      \code{posthoc.vanWaerden.test}, 
      for multiple comparisons following a significant omnibus test was
      added to the package.
      
      \item The Conover-test, \code{posthoc.friedman.conover.test}, 
      for multiple comparisons following a Friedman test was added
      to the package.
      
      \item The Conover-test, \code{posthoc.kruskal.conover.test}, 
      for multiple comparisons following a Kruskal test was added
      to the package.
      
      \item The NAMSPACE file, VIGNETTE and the .Rd files
      were updated accordingly.
    }
  }
  \subsection{BUGFIXES}{
    \itemize{
      \item \code{posthoc.kruskal.dunn.test} and
      \code{dunn.test.control} were corrected to calculate p-values for
      a two-sided test.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 2.0}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item The Dunn-test, \code{posthoc.kruskal.dunn.test}, 
      for multiple comparisons of rank sums was added to the package.
      Likewise, a Dunn-test for multiple comparisons with one control,
      \code{dunn.test.control}, was added.
      The NAMSPACE file, VIGNETTE and the .Rd files were updated accordingly.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 1.3}{
  \subsection{BUGFIXES}{
    \itemize{
      \item The examples in the LaTeX document (vignette) were corrected.
      The help pages were extended.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 1.2}{
  \subsection{BUGFIXES}{
    \itemize{
      \item The LaTeX document (vignette) was corrected to avoid
      compilation errors.
    }
  }
}
\section{CHANGES IN PMCMR VERSION 1.1}{
  \subsection{NEW FEATURES}{
    \itemize{
      \item A formula method \code{posthoc.kruskal.nemenyi.test.formula()} and
      \code{posthoc.friedman.nemenyi.formula()} was added 
      to the code in a similar fashion as it is coded in
  \code{kruskal.test} and \code{friedman.test} of the package
  \code{stats}. The NAMSPACE file and the .Rd files were updated accordingly.
    }
  }
}

