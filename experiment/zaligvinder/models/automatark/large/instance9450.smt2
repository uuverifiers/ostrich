(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[\u{22}\u{27}]?[^\n]*\u{2e}pif[\u{22}\u{27}\s]/si
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pif") (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/si\u{0a}")))))
; ^([(][1-9]{2}[)] )?[0-9]{4}[-]?[0-9]{4}$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re ") "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[3|4|5|6]([0-9]{15}$|[0-9]{12}$|[0-9]{13}$|[0-9]{14}$)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "3") (str.to_re "|") (str.to_re "4") (str.to_re "5") (str.to_re "6")) (re.union ((_ re.loop 15 15) (re.range "0" "9")) ((_ re.loop 12 12) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9")) ((_ re.loop 14 14) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
