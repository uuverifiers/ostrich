(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; e2give\.com.*Host\x3A.*Host\u{3a}
(assert (str.in_re X (re.++ (str.to_re "e2give.com") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:\u{0a}"))))
; \binterface\b.*(\bI[_]\w*\b)
(assert (str.in_re X (re.++ (str.to_re "interface") (re.* re.allchar) (str.to_re "\u{0a}I_") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; /\u{00}hide hide\u{22}\u{09}\u{22}([a-z0-9\u{5c}\u{2e}\u{3a}]+\u{2e}exe|sh)/
(assert (not (str.in_re X (re.++ (str.to_re "/\u{00}hide hide\u{22}\u{09}\u{22}") (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "\u{5c}") (str.to_re ".") (str.to_re ":"))) (str.to_re ".exe")) (str.to_re "sh")) (str.to_re "/\u{0a}")))))
; ^[F][O][\s]?[0-9]{3}$
(assert (str.in_re X (re.++ (str.to_re "FO") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(\d){7,8}$
(assert (str.in_re X (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
