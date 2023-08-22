(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\w\._-]){3,}\@([\w\-_.]){3,}\.(\w){2,4}$
(assert (not (str.in_re X (re.++ (str.to_re "@.") ((_ re.loop 2 4) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re ".") (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "-") (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))))))
; ^[a-zA-Z]([a-zA-Z0-9])*([\.][a-zA-Z]([a-zA-Z0-9])*)*$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; (\[[Ii][Mm][Gg]\])(\S+?)(\[\/[Ii][Mm][Gg]\])
(assert (not (str.in_re X (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}[") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "][/") (re.union (str.to_re "I") (str.to_re "i")) (re.union (str.to_re "M") (str.to_re "m")) (re.union (str.to_re "G") (str.to_re "g")) (str.to_re "]")))))
(assert (> (str.len X) 10))
(check-sat)
