(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; dialupvpn\u{5f}pwd\d\<title\>Actual\sSpywareStriketvlistingsUser-Agent\x3Auuid=aadserverfowclxccdxn\u{2f}uxwn\.ddy
(assert (not (str.in_re X (re.++ (str.to_re "dialupvpn_pwd") (re.range "0" "9") (str.to_re "<title>Actual") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "SpywareStriketvlistingsUser-Agent:uuid=aadserverfowclxccdxn/uxwn.ddy\u{0a}")))))
; ^04[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "04") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1}(\-| |){1}[0-9]{1}[a-zA-Z]{1}[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \d{5}\-\d{3}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
