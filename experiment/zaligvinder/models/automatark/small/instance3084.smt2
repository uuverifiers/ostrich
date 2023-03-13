(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(ht|f)tp(s?)\:\/\/(([a-zA-Z0-9\-\._]+(\.[a-zA-Z0-9\-\._]+)+)|localhost)(\/?)([a-zA-Z0-9\-\.\?\,\'\/\\\+&%\$#_]*)?([\d\w\.\/\%\+\-\=\&\?\:\\\"\'\,\|\~\;]*)$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")) (str.to_re "://") (re.union (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "_")))))) (str.to_re "localhost")) (re.opt (str.to_re "/")) (re.opt (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".") (str.to_re "?") (str.to_re ",") (str.to_re "'") (str.to_re "/") (str.to_re "\u{5c}") (str.to_re "+") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "_")))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "/") (str.to_re "%") (str.to_re "+") (str.to_re "-") (str.to_re "=") (str.to_re "&") (str.to_re "?") (str.to_re ":") (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "'") (str.to_re ",") (str.to_re "|") (str.to_re "~") (str.to_re ";") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; (^[0-9]*[1-9]+[0-9]*\.[0-9]*$)|(^[0-9]*\.[0-9]*[1-9]+[0-9]*$)|(^[0-9]*[1-9]+[0-9]*$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9"))) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))))))
; /^\u{2f}j\u{2f}[a-f0-9]{32}\u{2f}0001$/U
(assert (not (str.in_re X (re.++ (str.to_re "//j/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/0001/U\u{0a}")))))
; update\.cgi\s+wwwProbnymomspyo\u{2f}zowy
(assert (str.in_re X (re.++ (str.to_re "update.cgi") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwProbnymomspyo/zowy\u{0a}"))))
(check-sat)
