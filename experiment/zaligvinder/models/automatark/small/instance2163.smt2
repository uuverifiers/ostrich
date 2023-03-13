(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; LOGNetBusCookie\u{3a}Toolbar
(assert (str.in_re X (str.to_re "LOGNetBusCookie:Toolbar\u{0a}")))
; ppcdomain\x2Eco\x2EukBasic
(assert (str.in_re X (str.to_re "ppcdomain.co.ukBasic\u{0a}")))
; ^[0-9]{2}[-][0-9]{2}[-][0-9]{2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ((IT|LV)-?)?[0-9]{11}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "IT") (str.to_re "LV")) (re.opt (str.to_re "-")))) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pfb/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pfb/i\u{0a}")))))
(check-sat)
