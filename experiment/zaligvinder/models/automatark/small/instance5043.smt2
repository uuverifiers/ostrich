(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([-]?[0-9])$|^([-]?[1][0-2])$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (str.to_re "1") (re.range "0" "2")))))
; [\w\-_\+\(\)]{0,}[\.png|\.PNG]{4}
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "-") (str.to_re "_") (str.to_re "+") (str.to_re "(") (str.to_re ")") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 4 4) (re.union (str.to_re ".") (str.to_re "p") (str.to_re "n") (str.to_re "g") (str.to_re "|") (str.to_re "P") (str.to_re "N") (str.to_re "G"))) (str.to_re "\u{0a}")))))
; Norton customer service is a type of method used to care your personal or business computer system from any virus or spyware.
(assert (str.in_re X (re.++ (str.to_re "Norton customer service is a type of method used to care your personal or business computer system from any virus or spyware") re.allchar (str.to_re "\u{0a}"))))
; (^[1-9]$)|(^10$)
(assert (str.in_re X (re.union (re.range "1" "9") (str.to_re "10\u{0a}"))))
; adblock\x2Elinkz\x2Ecomwww\.iggsey\.comHost\x3A
(assert (str.in_re X (str.to_re "adblock.linkz.comwww.iggsey.comHost:\u{0a}")))
(check-sat)
