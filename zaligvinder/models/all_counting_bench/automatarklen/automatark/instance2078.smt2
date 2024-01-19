(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\+)?(\d{2})[-])?(([\(])?((\d){3,5})([\)])?[-])|(\d{3,5})(\d{5,8}){1}?$
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (str.to_re "-")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) ((_ re.loop 1 1) ((_ re.loop 5 8) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /Expression\u{28}\s*?GetClass\u{28}\u{22}sun.awt.SunToolkit\u{22}\u{29}\s*?,\s*?\u{22}getField\u{22}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/Expression(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "GetClass(\u{22}sun") re.allchar (str.to_re "awt") re.allchar (str.to_re "SunToolkit\u{22})") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ",") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}getField\u{22}/smi\u{0a}")))))
; URLUBAgent%3fSchwindlerurl=Host\u{3a}httpUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "URLUBAgent%3fSchwindlerurl=Host:httpUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
