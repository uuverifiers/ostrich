(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3ASpyxpsp2-Host\u{3a}Host\x3Awjpropqmlpohj\u{2f}loregister\.asp
(assert (not (str.in_re X (str.to_re "Host:Spyxpsp2-Host:Host:wjpropqmlpohj/loregister.asp\u{0a}"))))
; /filename=[^\n]*\u{2e}mov/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mov/i\u{0a}"))))
; <[\w\"\ '\#\* \=\',\.\\\(\)\/\-\$\{\}\[\]\|\*\?\+\^\&\:\%\;\!]+>
(assert (not (str.in_re X (re.++ (str.to_re "<") (re.+ (re.union (str.to_re "\u{22}") (str.to_re " ") (str.to_re "'") (str.to_re "#") (str.to_re "*") (str.to_re "=") (str.to_re ",") (str.to_re ".") (str.to_re "\u{5c}") (str.to_re "(") (str.to_re ")") (str.to_re "/") (str.to_re "-") (str.to_re "$") (str.to_re "{") (str.to_re "}") (str.to_re "[") (str.to_re "]") (str.to_re "|") (str.to_re "?") (str.to_re "+") (str.to_re "^") (str.to_re "&") (str.to_re ":") (str.to_re "%") (str.to_re ";") (str.to_re "!") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ">\u{0a}")))))
; ^((https|http)://)?(www.)?(([a-zA-Z0-9\-]{2,})\.)+([a-zA-Z0-9\-]{2,4})(/[\w\.]{0,})*((\?)(([\w\%]{0,}=[\w\%]{0,}&?)|[\w]{0,})*)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "https://")) (re.opt (re.++ (str.to_re "www") re.allchar)) (re.+ (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))))) ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.* (re.++ (str.to_re "/") (re.* (re.union (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.opt (re.++ (str.to_re "?") (re.* (re.union (re.++ (re.* (re.union (str.to_re "%") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.* (re.union (str.to_re "%") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.opt (str.to_re "&"))) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))) (str.to_re "\u{0a}"))))
(check-sat)
