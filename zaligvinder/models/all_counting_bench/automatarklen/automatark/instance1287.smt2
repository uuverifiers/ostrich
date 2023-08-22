(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; PortaUser-Agent\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "PortaUser-Agent:Host:\u{0a}"))))
; ^((\\){2})(([A-Za-z ',.;]+)(\\?)([A-Za-z ',.;]\\?)*)$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "\u{5c}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";"))) (re.opt (str.to_re "\u{5c}")) (re.* (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";")) (re.opt (str.to_re "\u{5c}"))))))))
; /\?spl=\d&br=[^&]+&vers=[^&]+&s=/H
(assert (not (str.in_re X (re.++ (str.to_re "/?spl=") (re.range "0" "9") (str.to_re "&br=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&vers=") (re.+ (re.comp (str.to_re "&"))) (str.to_re "&s=/H\u{0a}")))))
; password\x3B1\x3BOptixOwner\x3ABarwww\x2Eaccoona\x2Ecom
(assert (str.in_re X (str.to_re "password;1;OptixOwner:Barwww.accoona.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
