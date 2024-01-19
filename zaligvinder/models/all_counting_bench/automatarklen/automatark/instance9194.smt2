(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z\d]+(([\'\,\.\- #][a-zA-Z\d ])?[a-zA-Z\d]*[\.]*)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.opt (re.++ (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "#")) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (str.to_re ".")))) (str.to_re "\u{0a}"))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (not (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}"))))
; /filename=[^\n]*\u{2e}xlw/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xlw/i\u{0a}"))))
; ^[0-9]{5}([\s-]{1}[0-9]{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
