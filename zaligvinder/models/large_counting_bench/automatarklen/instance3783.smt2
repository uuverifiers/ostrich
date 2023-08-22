(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}qcp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".qcp/i\u{0a}")))))
; ^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.+ (str.to_re "_"))) (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.+ (str.to_re "-"))) (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.+ (str.to_re "."))) (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.+ (str.to_re "+"))))) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "@") (re.* (re.union (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (str.to_re "-"))) (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".")))) ((_ re.loop 1 63) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
