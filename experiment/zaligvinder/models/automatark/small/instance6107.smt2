(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[^ ,0]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re ",") (str.to_re "0"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}ppsx/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppsx/i\u{0a}"))))
; /filename\=[a-z0-9]{24}\.jar/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/H\u{0a}")))))
; ^(([a-z][0-9])|([0-9][a-z])|([a-z0-9][a-z0-9\-]{1,2}[a-z0-9])|([a-z0-9][a-z0-9\-](([a-z0-9\-][a-z0-9])|([a-z0-9][a-z0-9\-]))[a-z0-9\-]*[a-z0-9]))\.(co|me|org|ltd|plc|net|sch|ac|mod|nhs|police|gov)\.uk$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.range "a" "z") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "a" "z")) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) ((_ re.loop 1 2) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-")) (re.union (re.++ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-")) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-")))) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re ".") (re.union (str.to_re "co") (str.to_re "me") (str.to_re "org") (str.to_re "ltd") (str.to_re "plc") (str.to_re "net") (str.to_re "sch") (str.to_re "ac") (str.to_re "mod") (str.to_re "nhs") (str.to_re "police") (str.to_re "gov")) (str.to_re ".uk\u{0a}")))))
(check-sat)
