(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z])[a-zA-Z_-]*[\w_-]*[\S]$|^([a-zA-Z])[0-9_-]*[\S]$|^[a-zA-Z]*[\S]$
(assert (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (re.* (re.union (str.to_re "_") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.* (re.union (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ([A-Z]:\\[^/:\*;\/\:\?<>\|]+)|(\\{2}[^/:\*;\/\:\?<>\|]+)
(assert (not (str.in_re X (re.union (re.++ (re.range "A" "Z") (str.to_re ":\u{5c}") (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re ";") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|")))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re ";") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "|"))))))))
; ^[\w_.]{5,12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 12) (re.union (str.to_re "_") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
(check-sat)
