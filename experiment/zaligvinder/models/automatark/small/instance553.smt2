(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^<a[^>]*(http://[^"]*)[^>]*>([ 0-9a-zA-Z]+)</a>$
(assert (not (str.in_re X (re.++ (str.to_re "<a") (re.* (re.comp (str.to_re ">"))) (re.* (re.comp (str.to_re ">"))) (str.to_re ">") (re.+ (re.union (str.to_re " ") (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "</a>\u{0a}http://") (re.* (re.comp (str.to_re "\u{22}")))))))
; User-Agent\u{3a}\w+Owner\x3A
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:\u{0a}")))))
; ^([1-9]|[1-9]\d|[1-2]\d{2}|3[0-6][0-6])$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.range "0" "6") (re.range "0" "6"))) (str.to_re "\u{0a}")))))
(check-sat)
