(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http://\([a-zA-Z0-9_\-]\+\(\.[a-zA-Z0-9_\-]\+\)\+\)\+:\?[0-9]\?\(/*[a-zA-Z0-9_\-#]*\.*\)*?\?\(&*[a-zA-Z0-9;_+/.\-%]*-*=*[a-zA-Z0-9;_+/.\-%]*-*\)*
(assert (str.in_re X (re.++ (str.to_re "http://(") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+(.") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+)+)+:?") (re.range "0" "9") (str.to_re "?(") (re.* (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "#"))) (re.* (str.to_re ".")) (re.* (str.to_re ")")) (str.to_re "?(") (re.* (str.to_re "&")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re "=")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re ")")) (str.to_re "\u{0a}"))))
; (0?[1-9]|[12][0-9]|3[01])[.](0?[1-9]|1[012])[.]\d{4}
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re ".") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2")))) (str.to_re ".") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; search\u{2e}conduit\u{2e}com\d+sidebar\.activeshopper\.comUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "search.conduit.com") (re.+ (re.range "0" "9")) (str.to_re "sidebar.activeshopper.comUser-Agent:\u{0a}")))))
; /filename=[^\n]*\u{2e}pdf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pdf/i\u{0a}"))))
(check-sat)
