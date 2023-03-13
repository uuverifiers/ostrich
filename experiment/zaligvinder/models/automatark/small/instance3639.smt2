(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((100)|(\d{0,2}))$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "100") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; protocol\s+3A\s+data2\.activshopper\.comUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "protocol") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "3A") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "data2.activshopper.comUser-Agent:\u{0a}"))))
; /filename=[^\n]*\u{2e}ets/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ets/i\u{0a}")))))
(check-sat)
