(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\d{8})|(\d{10})|(\d{11})|(\d{6}-\d{5}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 10 10) (re.range "0" "9")) ((_ re.loop 11 11) (re.range "0" "9")) (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 5 5) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}")))))
; ^(\+48\s+)?\d{3}(\s*|\-)\d{3}(\s*|\-)\d{3}$
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+48") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; DA\dwww\x2Ee-finder\x2Ecc.*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "DA") (re.range "0" "9") (str.to_re "www.e-finder.cc") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
(check-sat)
