(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; <title>(.*?)</title>
(assert (not (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}")))))
; /\u{2e}mpeg([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.mpeg") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[a-zA-Z0-9\-\.]+\.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".") (re.union (str.to_re "com") (str.to_re "org") (str.to_re "net") (str.to_re "mil") (str.to_re "edu") (str.to_re "COM") (str.to_re "ORG") (str.to_re "NET") (str.to_re "MIL") (str.to_re "EDU")) (str.to_re "\u{0a}"))))
; ^(100([\.\,]0{1,2})?)|(\d{1,2}[\.\,]\d{1,2})|(\d{0,2})$
(assert (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^([0-9]{4})([0-9]{5})([0-9]{1})$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
