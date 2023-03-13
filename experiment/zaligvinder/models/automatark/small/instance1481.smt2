(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jfi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jfi/i\u{0a}"))))
; [0-9]*\.?[0-9]*[1-9]
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.range "1" "9") (str.to_re "\u{0a}")))))
; /filename\=[a-z0-9]{24}\.exe/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/H\u{0a}")))))
; /filename=[^\n]*\u{2e}j2k/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".j2k/i\u{0a}")))))
; /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9") (str.to_re "~") (str.to_re "!") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "_") (str.to_re "=") (str.to_re "+") (str.to_re "}") (str.to_re "{") (str.to_re "'") (str.to_re "?"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9") (str.to_re "~") (str.to_re "!") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "&") (str.to_re "*") (str.to_re "_") (str.to_re "=") (str.to_re "+") (str.to_re "}") (str.to_re "{") (str.to_re "'") (str.to_re "?"))))) (str.to_re "@") (re.union (re.++ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_")) (re.* (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))))) (str.to_re ".") (re.union (str.to_re "aero") (str.to_re "arpa") (str.to_re "biz") (str.to_re "com") (str.to_re "coop") (str.to_re "edu") (str.to_re "gov") (str.to_re "info") (str.to_re "int") (str.to_re "mil") (str.to_re "museum") (str.to_re "name") (str.to_re "net") (str.to_re "org") (str.to_re "pro") (str.to_re "travel") (str.to_re "mobi") (re.++ (re.range "a" "z") (re.range "a" "z")))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "/i\u{0a}")))))
(check-sat)
