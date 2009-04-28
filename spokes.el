;;; begin spokes.el
; version 0.2 with automatic context-sensitive on-line help
; LaTeX option added
; 07/29/1999

(defun bike-spokes () "Calculate spoke lengths" (interactive)

; Using this program:
;
; After separating out the "measure.txt" file and saving it somewhere,
; modify the line below (marked MODIFY) to reflect where you put the
; measure.txt file.  Then byte-compile this program (spokes.el).  Put
; the spokes.elc file somewhere in your emacs load path.
;
; You can either load when needed, or autoload in your .emacs file.
; Your choice.
;
; Output is concatenated if multiple runs are made in the same
; Emacs session, allowing you to figure out all the necessary spoke
; lengths for your wheel and have them, fully documented, in a single
; buffer.  Don't forget to save or print the buffer!
;
; This is no surprise:
; LaTeX output is now an option.  The program more or less assumes
; that you have the auctex package installed or some means of using
; LaTeX mode.  Barring this you should remove (latex-mode) in the
; code down below.
;
; The data input is not particularly self-explanatory.  Please view the
; measure.txt file included with this application, or better yet visit
; Robert Torre's excellent web site:
;
;     http://home.cdsnet.net/~rtower/spoke&wheel.info/home.htm
;
; Specific measurement definitions are found at
;
;     http://home.cdsnet.net/~rtower/spoke&wheel.info/measure.htm
;
; The Web site will show you the graphics that cannot be shown in
; the measure.txt file (which comes from the web site).  The Web site
; also describes how to make calculations for exotic lacing patterns,
; and contains some of the best information and links on the web about
; wheel building.
;
; Information and formulas in this package are taken, with permission,
; from Robert Torre's web pages.  Thank you Robert for your contributions
; to the bicycling community.  This program is a small payback.
;
; The program nows runs with automatic help keyed to the input parameter.
; To scroll the information window, switch to it
; (ctrl-x o)
; and look up the info you need.  Then go back to the minibuffer to
; enter your input
; (crtl-x o)
;
; This program is released into the public domain.  Please send comments,
; suggestions, and bug reports or fixes to
;
; bnewell@alum.mit.edu
;
(if (switch-to-buffer "measure.txt")
    (kill-buffer "measure.txt"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MODIFY this line to reflect where you put the measure.txt file:
(find-file "~/measure.txt")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(switch-to-buffer "measure.txt")
(delete-other-windows)
(goto-char (point-min))

(setq latex-output (yes-or-no-p "LaTeX output? "))
(cond ( latex-output
; If there is no LaTeX spokes buffer assume first time through
     (cond ( (not (get-buffer "spokes.tex"))
             (setq spoke-buffer (get-buffer-create "spokes.tex"))
               (switch-to-buffer spoke-buffer)
               (goto-char (point-max))
               (insert "\n")
               ; LaTeX headers
               (insert "\\documentclass[12pt]{article}\n")
               (insert "\\begin{document}\n")
               (insert "\\thispagestyle{empty}\n")
               (insert "\\begin{center}\n")
               (insert "{\\bf Spoke Length Calculations} \\\\ \n")
               (insert "\\end{center}\n")
               (insert "\\vspace{.5in}\n")
           )
           (t
;  Get rid of end document so it isn't duplicated later
              (switch-to-buffer spoke-buffer)
              (goto-char (point-min))
              (search-forward "end{docu")
              (beginning-of-line)
              (kill-line)
              )
      )
     )
      (t
; If there is no text spokes buffer assume first time through
        (if ( not (get-buffer "spokes.txt"))
           (setq spoke-buffer (get-buffer-create "spokes.txt")))
         )
   )

(switch-to-buffer "measure.txt")
(goto-char (point-min))
(setq radial
   (yes-or-no-p "Default is laced, do you want radial instead? " ))

; Repeat goto-char each time as the window may have been scrolled.
(switch-to-buffer "measure.txt")
(goto-char (point-min))
(search-forward "first measurement to take will be")
(recenter 0)
(setq hsd (float (string-to-number
   (read-string "Enter hub spoke diameter in mm: "))))
(switch-to-buffer "measure.txt")
(goto-char (point-min))
(search-forward "the rim dimensions the first measurement")
(recenter 0)
(setq rd (float (string-to-number
   (read-string "Enter rim diameter in mm: "))))
(switch-to-buffer "measure.txt")
(goto-char (point-min))
(search-forward "how deeply the spoke will penetrate")
(recenter 0)
(setq sp (float (string-to-number
   (read-string "Enter spoke penetration (3-4mm is typical): "))))
(switch-to-buffer "measure.txt")
(goto-char (point-min))
(search-forward "need is the hub flange offset")
(recenter 0)
(setq hfo (float (string-to-number
   (read-string "Enter hub flange offset in mm: "))))

(cond ( latex-output
          (switch-to-buffer spoke-buffer)
          (goto-char (point-max))
          (insert "\\begin{tabbing}\n")
          (insert "xxxxxxxxxxxxxxxxxxxxxxxx\\=\\kill\n")
          (insert (format "Hub spoke diameter\\>: %.2f mm \\\\ \n" hsd))
          (insert (format "Rim  diameter     \\>: %.2f mm \\\\ \n" rd))
          (insert (format "Spoke penetration \\>: %.2f mm \\\\ \n" sp))
          (insert (format "Hub flange offset \\>: %.2f mm \\\\ \n" hfo))
      )
      (t
          (switch-to-buffer spoke-buffer)
          (goto-char (point-max))
          (insert (format "Hub spoke diameter: %.2f mm \n" hsd))
          (insert (format "Rim  diameter     : %.2f mm \n" rd))
          (insert (format "Spoke penetration : %.2f mm \n" sp))
          (insert (format "Hub flange offset : %.2f mm \n" hfo))
      )
)

(setq hsr (/ hsd 2.0))
(setq rrsp (+ sp (/ rd 2.0)))

(cond ( (not radial)
   (switch-to-buffer "measure.txt")
   (goto-char (point-min))
   (search-forward "you now calculate the spoke anchor")
   (recenter 0)
   (setq ncross (float (string-to-number
     (read-string "Enter number of crosses: "))))
   (setq nspoke (float (string-to-number
     (read-string "Enter number of spokes: "))))
   (cond (latex-output
            (switch-to-buffer spoke-buffer)
            (goto-char (point-max))
            (insert (format "Number of crosses \\>: %.0f \\\\ \n" ncross))
            (insert (format "Number of spokes  \\>: %.0f \\\\ \n" nspoke))
          )
         (t
            (switch-to-buffer spoke-buffer)
            (goto-char (point-max))
            (insert (format "Number of crosses : %.0f \n" ncross))
            (insert (format "Number of spokes  : %.0f \n" nspoke))
          )
   )
   (setq saa  (*  (/ ncross nspoke) 12.5663704))
   (setq hsrcos (* hsr (cos saa) ))
   ; Laced spoke formula
   (setq sl (sqrt  
      (- (+ (expt (- rrsp hsrcos) 2.0) (* hfo hfo) (* hsr hsr))
                                           (* hsrcos hsrcos))))
      )
; radial spoke formula
  (t
     (setq sl (sqrt
         (+ (expt (- rrsp hsr) 2.0) (* hfo hfo))))
  )
)

(cond
 (latex-output
    (switch-to-buffer spoke-buffer)
    (goto-char (point-max))
    (insert (format "SPOKE LENGTH\\>: %.2f mm \\\\ \n" sl))
    (insert "\\end{tabbing}\n")
    (insert "\\end{document} \n")
    (latex-mode)
    (write-file "spokes.tex")
 )
 (t
    (switch-to-buffer spoke-buffer)
    (goto-char (point-max))
    (insert (format "SPOKE LENGTH      : %.2f mm \n \n" sl))
 )
)

)

;;; end spokes.el
