(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9\-\.]+\.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") (re.union (str.to_re "com") (str.to_re "org") (str.to_re "net") (str.to_re "mil") (str.to_re "edu") (str.to_re "COM") (str.to_re "ORG") (str.to_re "NET") (str.to_re "MIL") (str.to_re "EDU")) (str.to_re "\u{0a}")))))
; ([A-Z]:\\[^/:\*\?<>\|]+\.\w{2,6})|(\\{2}[^/:\*\?<>\|]+\.\w{2,6})
(assert (not (str.in_re X (re.union (re.++ (re.range "A" "Z") (str.to_re ":\u{5c}") (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))))
; /\u{2f}panda\u{2f}\u{3f}u\u{3d}[a-z0-9]{32}/U
(assert (str.in_re X (re.++ (str.to_re "//panda/?u=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
