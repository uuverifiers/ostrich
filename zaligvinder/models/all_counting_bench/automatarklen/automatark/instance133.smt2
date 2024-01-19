(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; trustyfiles\x2EcomBlade\u{23}\u{23}\u{23}\u{23}\.smx\?
(assert (str.in_re X (str.to_re "trustyfiles.comBlade####.smx?\u{0a}")))
; (.*\.jpe?g|.*\.JPE?G)
(assert (str.in_re X (re.++ (re.union (re.++ (re.* re.allchar) (str.to_re ".jp") (re.opt (str.to_re "e")) (str.to_re "g")) (re.++ (re.* re.allchar) (str.to_re ".JP") (re.opt (str.to_re "E")) (str.to_re "G"))) (str.to_re "\u{0a}"))))
; ^[\w_.]{5,12}$
(assert (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; configINTERNAL\.inikwdwww\x2Ewordiq\x2Ecomas\x2Estarware\x2Ecom
(assert (not (str.in_re X (str.to_re "configINTERNAL.inikwdwww.wordiq.com\u{1b}as.starware.com\u{0a}"))))
; /filename=[^\n]*\u{2e}qt/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qt/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
