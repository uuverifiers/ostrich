(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; filename=\u{22}\s+www\x2Epeer2mail\x2Ecom.*LOG
(assert (str.in_re X (re.++ (str.to_re "filename=\u{22}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.peer2mail.com") (re.* re.allchar) (str.to_re "LOG\u{0a}"))))
; /filename=[^\n]*\u{2e}vqf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vqf/i\u{0a}"))))
; \b[P|p]?(OST|ost)?\.?\s*[O|o|0]?(ffice|FFICE)?\.?\s*[B|b][O|o|0]?[X|x]?\.?\s+[#]?(\d+)\b
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "P") (str.to_re "|") (str.to_re "p"))) (re.opt (re.union (str.to_re "OST") (str.to_re "ost"))) (re.opt (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "O") (str.to_re "|") (str.to_re "o") (str.to_re "0"))) (re.opt (re.union (str.to_re "ffice") (str.to_re "FFICE"))) (re.opt (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "B") (str.to_re "|") (str.to_re "b")) (re.opt (re.union (str.to_re "O") (str.to_re "|") (str.to_re "o") (str.to_re "0"))) (re.opt (re.union (str.to_re "X") (str.to_re "|") (str.to_re "x"))) (re.opt (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "#")) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\x2Fdirect\.php\x3Ff=[0-9]{8}\u{26}s=[a-z0-9]{3}\.[a-z]{1,4}/U
(assert (str.in_re X (re.++ (str.to_re "//direct.php?f=") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "&s=") ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 1 4) (re.range "a" "z")) (str.to_re "/U\u{0a}"))))
(check-sat)
