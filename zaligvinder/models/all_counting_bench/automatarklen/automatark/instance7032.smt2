(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\s*(http[s]*\:\/\/)?([wwW]{3}\.)+[a-zA-Z0-9]+\.[a-zA-Z]{2,3}.*$|^http[s]*\:\/\/[^w]{3}[a-zA-Z0-9]+\.[a-zA-Z]{2,3}.*$|http[s]*\:\/\/[0-9]{2,3}\.[0-9]{2,3}\.[0-9]{2,3}\.[0-9]{2,3}.*$/;
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (str.to_re "http") (re.* (str.to_re "s")) (str.to_re "://"))) (re.+ (re.++ ((_ re.loop 3 3) (re.union (str.to_re "w") (str.to_re "W"))) (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* re.allchar)) (re.++ (str.to_re "http") (re.* (str.to_re "s")) (str.to_re "://") ((_ re.loop 3 3) (re.comp (str.to_re "w"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* re.allchar)) (re.++ (str.to_re "http") (re.* (str.to_re "s")) (str.to_re "://") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 3) (re.range "0" "9")) (re.* re.allchar) (str.to_re "/;\u{0a}"))))))
; [^a-zA-Z \-]|(  )|(\-\-)|(^\s*$)
(assert (str.in_re X (re.union (str.to_re "  ") (str.to_re "--") (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")) (re.range "a" "z") (re.range "A" "Z") (str.to_re " ") (str.to_re "-"))))
; encoder[^\n\r]*\.cfg\s+Host\x3AWeHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "encoder") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re ".cfg") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:WeHost:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
