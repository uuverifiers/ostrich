(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /version\x3D[\u{22}\u{27}][^\u{22}\u{27}]{1024}/
(assert (not (str.in_re X (re.++ (str.to_re "/version=") (re.union (str.to_re "\u{22}") (str.to_re "'")) ((_ re.loop 1024 1024) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/\u{0a}")))))
; \b[P|p]?(OST|ost)?\.?\s*[O|o|0]?(ffice|FFICE)?\.?\s*[B|b][O|o|0]?[X|x]?\.?\s+[#]?(\d+)\b
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "P") (str.to_re "|") (str.to_re "p"))) (re.opt (re.union (str.to_re "OST") (str.to_re "ost"))) (re.opt (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "O") (str.to_re "|") (str.to_re "o") (str.to_re "0"))) (re.opt (re.union (str.to_re "ffice") (str.to_re "FFICE"))) (re.opt (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "B") (str.to_re "|") (str.to_re "b")) (re.opt (re.union (str.to_re "O") (str.to_re "|") (str.to_re "o") (str.to_re "0"))) (re.opt (re.union (str.to_re "X") (str.to_re "|") (str.to_re "x"))) (re.opt (str.to_re ".")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "#")) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
