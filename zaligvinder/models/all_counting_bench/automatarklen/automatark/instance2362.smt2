(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}avi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}"))))
; ^[a-zA-Z0-9\_\-]+[a-zA-Z0-9\.\_\-]*@([a-zA-Z0-9\_\-]+\.)+([a-zA-Z]{2,4}|travel|museum)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re "@") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "."))) (re.union ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "travel") (str.to_re "museum")) (str.to_re "\u{0a}"))))
; ^[1]?[-\.\s]?(\(\d{3}\)|\d{3}){1}[-\.\s]?\d{3}[-\.\s]?\d{4}(\s+|\s*[-\.x]{1}\d{1,6})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re ".") (str.to_re "x"))) ((_ re.loop 1 6) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; s/\b(\w+)\b/ucfirst($1)/ge
(assert (not (str.in_re X (re.++ (str.to_re "s/") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/ucfirst1/ge\u{0a}")))))
; offers\x2Ebullseye-network\x2Ecom\s+news[^\n\r]*WatcherUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "offers.bullseye-network.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "news") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "WatcherUser-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
