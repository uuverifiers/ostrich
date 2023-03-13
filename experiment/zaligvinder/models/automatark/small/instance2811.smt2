(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; http://\([a-zA-Z0-9_\-]\+\(\.[a-zA-Z0-9_\-]\+\)\+\)\+:\?[0-9]\?\(/*[a-zA-Z0-9_\-#]*\.*\)*?\?\(&*[a-zA-Z0-9;_+/.\-%]*-*=*[a-zA-Z0-9;_+/.\-%]*-*\)*
(assert (str.in_re X (re.++ (str.to_re "http://(") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+(.") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")) (str.to_re "+)+)+:?") (re.range "0" "9") (str.to_re "?(") (re.* (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "#"))) (re.* (str.to_re ".")) (re.* (str.to_re ")")) (str.to_re "?(") (re.* (str.to_re "&")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re "=")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ";") (str.to_re "_") (str.to_re "+") (str.to_re "/") (str.to_re ".") (str.to_re "-") (str.to_re "%"))) (re.* (str.to_re "-")) (re.* (str.to_re ")")) (str.to_re "\u{0a}"))))
; ^(s-|S-){0,1}[0-9]{3}\s?[0-9]{2}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "s-") (str.to_re "S-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[1-9][0-9]{0,6}(|.[0-9]{1,2}|,[0-9]{1,2})?
(assert (str.in_re X (re.++ (re.range "1" "9") ((_ re.loop 0 6) (re.range "0" "9")) (re.opt (re.union (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; toolbar_domain_redirectlibManager\x2Edll\x5Eget
(assert (str.in_re X (str.to_re "toolbar_domain_redirectlibManager.dll^get\u{0a}")))
; /\u{2e}exe([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.exe") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
