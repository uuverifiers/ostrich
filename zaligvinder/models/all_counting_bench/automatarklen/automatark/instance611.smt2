(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (not (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
; Host\u{3a}\dgpstool\u{2e}globaladserver\u{2e}comdesksearch\.dropspam\.com
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "gpstool.globaladserver.comdesksearch.dropspam.com\u{0a}")))))
; www\x2Emyarmory\x2EcomHost\u{3a}Host\u{3a}messagessearch\u{2e}imesh\u{2e}com
(assert (not (str.in_re X (str.to_re "www.myarmory.comHost:Host:messagessearch.imesh.com\u{0a}"))))
; [^A-Za-z0-9_@\.]|@{2,}|\.{5,}
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (str.to_re "@")) (re.* (str.to_re "@"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (str.to_re ".")) (re.* (str.to_re "."))) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re ".")))))
; (^\$(\d{1,3},?(\d{3},?)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{2})?)$|^\d{1,2}(\.\d{1,2})? *%$|^100%$)
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "$") (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re ",")) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9"))))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (re.* (str.to_re " ")) (str.to_re "%")) (str.to_re "100%")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
