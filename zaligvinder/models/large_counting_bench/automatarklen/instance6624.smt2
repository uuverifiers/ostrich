(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]{4}\.html\?j\=\d{6,7}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 4) (re.range "a" "z")) (str.to_re ".html?j=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; \{[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\}
(assert (str.in_re X (re.++ (str.to_re "{") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "a" "f") (re.range "A" "F") (re.range "0" "9"))) (str.to_re "}\u{0a}"))))
; /^\/\/?[a-z0-9_]{7,8}\/\??[0-9a-f]{60,68}[\u{3b}\u{2c}\d+]*$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.opt (str.to_re "/")) ((_ re.loop 7 8) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "/") (re.opt (str.to_re "?")) ((_ re.loop 60 68) (re.union (re.range "0" "9") (re.range "a" "f"))) (re.* (re.union (str.to_re ";") (str.to_re ",") (re.range "0" "9") (str.to_re "+"))) (str.to_re "/U\u{0a}")))))
; www\.trackhits\.cc\s+wwwHost\u{3a}RobertVersionspyblini\x2Eini
(assert (str.in_re X (re.++ (str.to_re "www.trackhits.cc") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "wwwHost:RobertVersionspyblini.ini\u{0a}"))))
; /^\/[a-f0-9]{32}\/[a-z]{1,15}-[a-z]{1,15}\.php/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 1 15) (re.range "a" "z")) (str.to_re "-") ((_ re.loop 1 15) (re.range "a" "z")) (str.to_re ".php/U\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
