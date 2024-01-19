(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-1]?[0-9])|([2][0-3])):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; s/\b(\w+)\b/ucfirst($1)/ge
(assert (str.in_re X (re.++ (str.to_re "s/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/ucfirst1/ge\u{0a}"))))
; ^([+a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,6}|[0-9]{1,3})(\]?)$
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "+") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".")))) (re.union ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 3) (re.range "0" "9"))) (re.opt (str.to_re "]")) (str.to_re "\u{0a}"))))
; ZC-Bridge\w+USER-AttachedReferer\x3AyouPointsUser-Agent\x3AHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "ZC-Bridge") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "USER-AttachedReferer:youPointsUser-Agent:Host:\u{0a}"))))
; /^images.php\?t=\d{2,7}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/images") re.allchar (str.to_re "php?t=") ((_ re.loop 2 7) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
