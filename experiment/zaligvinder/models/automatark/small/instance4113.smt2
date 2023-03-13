(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 1?[ \.\-\+]?[(]?([0-9]{3})?[)]?[ \.\-\+]?[0-9]{3}[ \.\-\+]?[0-9]{4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fbar_pl\x2Fchk_bar\.fcgiUser-Agent\x3A
(assert (str.in_re X (str.to_re "/bar_pl/chk_bar.fcgiUser-Agent:\u{0a}")))
; /filename=[^\n]*\u{2e}hlp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hlp/i\u{0a}")))))
(check-sat)
