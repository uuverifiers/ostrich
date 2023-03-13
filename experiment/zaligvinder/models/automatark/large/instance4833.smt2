(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+)?(\d{2}[-])?(\d{10}){1})?(\d{11}){0,1}?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) (re.opt (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 1 1) ((_ re.loop 10 10) (re.range "0" "9"))))) (re.opt ((_ re.loop 11 11) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /\u{2e}xslt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.xslt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /[^&]+&[a-z]=[a-f0-9]{16}&[a-z]=[a-f0-9]{16}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&") (re.range "a" "z") (str.to_re "=") ((_ re.loop 16 16) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; User-Agent\x3A\s+\x7D\x7BPassword\x3A\d+information
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "}{Password:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "information\u{0a}"))))
; \x2Fpagead\x2Fads\?\d+ocllceclbhs\u{2f}gth
(assert (str.in_re X (re.++ (str.to_re "/pagead/ads?") (re.+ (re.range "0" "9")) (str.to_re "ocllceclbhs/gth\u{0a}"))))
(check-sat)
