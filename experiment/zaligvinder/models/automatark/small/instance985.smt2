(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}tif/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tif/i\u{0a}")))))
; /gate\u{2e}php\u{3f}reg=[a-z]{10}/U
(assert (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 10 10) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
; DigExtNetBus\x5BStatic
(assert (not (str.in_re X (str.to_re "DigExtNetBus[Static\u{0a}"))))
(check-sat)
