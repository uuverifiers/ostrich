(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\+65)?\d{8}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "+65")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; http://\([a-zA-Z0-9_\-]\+\(\.[a-zA-Z0-9_\-]\+\)\+\)\+:\?[0-9]\?\(/*[a-zA-Z0-9_\-#]*\.*\)*?\?\(&*[a-zA-Z0-9;_+/.\-%]*-*=*[a-zA-Z0-9;_+/.\-%]*-*\)*
(assert (not (str.in_re X (re.++ (str.to_re "http://(") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+(.") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+)+)+:?") (re.range "0" "9") (str.to_re "?(") (re.* (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "#"))) (re.* (str.to_re ".")) (re.* (str.to_re ")")) (str.to_re "?(") (re.* (str.to_re "&")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re "=")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re ")")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
