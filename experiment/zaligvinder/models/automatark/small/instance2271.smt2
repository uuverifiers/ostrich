(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-5]$
(assert (str.in_re X (re.++ (re.range "1" "5") (str.to_re "\u{0a}"))))
; \x0D\x0ACurrent\x2EearthlinkSpyBuddy
(assert (not (str.in_re X (str.to_re "\u{0d}\u{0a}Current.earthlinkSpyBuddy\u{0a}"))))
; Admin\s+daosearch\x2EcomMyPostwww\.raxsearch\.comref\x3D\u{25}user\x5Fid
(assert (str.in_re X (re.++ (str.to_re "Admin") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.comMyPostwww.raxsearch.comref=%user_id\u{0a}"))))
; \b[\w]+[\w.-][\w]+@[\w]+[\w.-]\.[\w]{2,4}\b
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re ".") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; (^(\+?\-? *[0-9]+)([,0-9 ]*)([0-9 ])*$)|(^ *$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.union (str.to_re ",") (re.range "0" "9") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re " "))) (re.opt (str.to_re "+")) (re.opt (str.to_re "-")) (re.* (str.to_re " ")) (re.+ (re.range "0" "9"))) (re.++ (re.* (str.to_re " ")) (str.to_re "\u{0a}"))))))
(check-sat)
