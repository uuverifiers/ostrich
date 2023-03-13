(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\u{3f}dp\u{3d}[A-Z0-9]{50}&cb\u{3d}[0-9]{9}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?dp=") ((_ re.loop 50 50) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cb=") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}exe/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".exe/i\u{0a}")))))
; /\.png$/Ui
(assert (str.in_re X (str.to_re "/.png/Ui\u{0a}")))
; ookflolfctm\u{2f}nmot\.fmu
(assert (str.in_re X (str.to_re "ookflolfctm/nmot.fmu\u{0a}")))
; Logger.*aresflashdownloader\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Logger") (re.* re.allchar) (str.to_re "aresflashdownloader.com\u{0a}")))))
(check-sat)
