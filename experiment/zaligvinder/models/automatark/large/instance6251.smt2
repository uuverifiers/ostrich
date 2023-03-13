(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A00000www\x2Ezhongsou\x2Ecom
(assert (str.in_re X (str.to_re "Host:00000www.zhongsou.com\u{0a}")))
; /filename=[^\n]*\u{2e}mny/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mny/i\u{0a}"))))
; ^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([;.](([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$
(assert (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 1 25) ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z")))))) (re.* (re.++ (re.union (str.to_re ";") (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 1 25) ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z")))))))) (str.to_re "\u{0a}"))))
; /^[a-zA-Z0-9]+$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/\u{0a}"))))
(check-sat)
