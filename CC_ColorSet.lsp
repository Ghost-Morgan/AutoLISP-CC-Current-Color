;;; =====================================================================
;;  CC_ColorSet.lsp
;;  Custom command: CC  (Change/Current Color)
;;  Replaces the workflow of typing:  -COLOR <enter> <colorname/number> <enter>
;;  with:                              CC <enter> <key> <enter>
;;
;;  Sets the CURRENT (active) drawing color for new objects, exactly like
;;  the native -COLOR command does. It does NOT touch existing objects.
;;
;;  Keys:  R Red | G Green | B Blue | Y Yellow | W White | C Cyan
;;         M Magenta | 8 Color8 | 9 Color9 | LA ByLayer | K ByBlock
;;
;;  PERFORMANCE NOTE: earlier drafts wrapped (command "_.-COLOR" ...),
;;  which goes through AutoCAD's full command dispatcher (undo marker,
;;  regen flag, command-line echo). This version sets CECOLOR directly
;;  via setvar, which is what -COLOR does internally for a plain
;;  numeral/BYLAYER/BYBLOCK value anyway, skipping that overhead.
;;  If you were seeing a 1-2 sec lag, it was NOT caused by this file's
;;  own logic (no loops, no delays, no heavy calls existed before
;;  either) â€” most likely causes are the file being reloaded from disk
;;  each time instead of sitting in your Startup Suite, or interaction
;;  with another loaded LISP (XXL) doing work on every command call.
;;  The CECOLOR change below removes the one real overhead source that
;;  WAS in this file; if lag persists it is coming from outside it.
;;
;;  Uses getkword/initget: shows the bracketed dropdown at the command
;;  line AND a clickable cursor popup, same as native AutoCAD prompts.
;;  Numerals are valid initget keywords per the AutoLISP reference;
;;  "8"/"9" work fine here since this prompt takes no point/distance
;;  input alongside them (the only case that causes ambiguity).
;;
;;  R G B Y W C M and LA/K sit on the LEFT-HAND side of a standard
;;  QWERTY keyboard. 8 and 9 sit on the top number row, right side on
;;  a full keyboard, kept as bare digit options.
;;
;;  LA is used only as a keyword inside this command; it does not redefine
;;  AutoCAD's standard "LA" (LAYER) command.
;;
;;  Does not conflict with: L, LI, LT, C, CO, CP, E, M, X, XR, or any
;;  other standard AutoCAD alias. "CC" is unused by default.
;;  Test this command alongside XXL in a sample drawing before production use.
;; =====================================================================

(defun *cc-error* (msg)
  (if (not (member msg '("Function cancelled" "quit / exit abort")))
    (princ (strcat "\nCC error: " msg))
  )
  (princ)
)

(defun c:CC ( / key clr olderr)

  (setq olderr *error*)
  (setq *error* *cc-error*)

  ;; getkword shows the native bracketed dropdown + clickable cursor
  ;; menu. initget's keyword string lists every valid entry; typing
  ;; an unambiguous prefix (or clicking the popup option) selects it.
  ;; clr stays nil until a recognized keyword maps to a value, so any
  ;; unexpected getkword return (should not happen, but no assumption
  ;; is trusted blindly) re-loops instead of feeding nil into setvar.
  (setq clr nil)
  (while (not clr)
    (setq key nil)
    (while (not key)
      (initget "Red Green Blue Yellow White Cyan Magenta 8 9 LA byblocK")
      (setq key (getkword
        "\nColor [Red/Green/Blue/Yellow/White/Cyan/Magenta/8/9/LA-byLayer/byblocK]: "))
    )
    (setq clr
      (cond
        ((= key "Red") 1)
        ((= key "Green") 3)
        ((= key "Blue") 5)
        ((= key "Yellow") 2)
        ((= key "White") 7)
        ((= key "Cyan") 4)
        ((= key "Magenta") 6)
        ((= key "8") 8)
        ((= key "9") 9)
        ((= key "LA") "BYLAYER")
        ((= key "byblocK") "BYBLOCK")
      )
    )
  )

  ;; CECOLOR takes a string in both cases: a numeral string ("1") for
  ;; ACI colors, or the literal "BYLAYER"/"BYBLOCK". clr is only ever
  ;; an integer or one of those two strings (see the cond above), so
  ;; check type before converting â€” itoa on a string would error.
  (if (numberp clr)
    (setvar "CECOLOR" (itoa clr))
    (setvar "CECOLOR" clr)
  )
  (princ (strcat "\nCurrent color: " (vl-princ-to-string clr)))

  (setq *error* olderr)
  (princ)
)

(princ "\nCC command loaded. Type CC then: R G B Y W C M 8 9 LA K")
(princ)
