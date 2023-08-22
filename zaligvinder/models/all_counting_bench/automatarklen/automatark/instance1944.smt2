(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [-'a-zA-Z]
(assert (str.in_re X (re.++ (re.union (str.to_re "-") (str.to_re "'") (re.range "a" "z") (re.range "A" "Z")) (str.to_re "\u{0a}"))))
; ^([012346789][0-9]{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9")) ((_ re.loop 4 4) (re.range "0" "9")))))
; /\.php\?catalogp\=\d{2}$/U
(assert (str.in_re X (re.++ (str.to_re "/.php?catalogp=") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
; ^[a-zA-Z0-9\-\.]+\.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") (re.union (str.to_re "com") (str.to_re "org") (str.to_re "net") (str.to_re "mil") (str.to_re "edu") (str.to_re "COM") (str.to_re "ORG") (str.to_re "NET") (str.to_re "MIL") (str.to_re "EDU")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
