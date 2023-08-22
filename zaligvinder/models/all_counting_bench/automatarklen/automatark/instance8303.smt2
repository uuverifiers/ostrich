(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1}[0-9]{3}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((([\(]?[2-9]{1}[0-9]{2}[\)]?)|([2-9]{1}[0-9]{2}\.?)){1}[ ]?[2-9]{1}[0-9]{2}[\-\.]{1}[0-9]{4})([ ]?[xX]{1}[ ]?[0-9]{3,4})?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.union (str.to_re "x") (str.to_re "X"))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (re.++ (re.opt (str.to_re "(")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re ")"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "."))))) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 4 4) (re.range "0" "9")))))
; onAlertMGS-Internal-Web-Manager
(assert (str.in_re X (str.to_re "onAlertMGS-Internal-Web-Manager\u{0a}")))
; Agent.*as\x2Estarware\x2Ecom\s+ServerToolbarcojud\x2Edmcast\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Agent") (re.* re.allchar) (str.to_re "as.starware.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ServerToolbarcojud.dmcast.com\u{0a}"))))
; /filename=[^\n]*\u{2e}bak/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bak/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
