(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((http|https|ftp):\/\/)?((.*?):(.*?)@)?([a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])((\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])*)(:([0-9]{1,5}))?((\/.*?)(\?(.*?))?(\#(.*))?)?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "http") (str.to_re "https") (str.to_re "ftp")) (str.to_re "://"))) (re.opt (re.++ (re.* re.allchar) (str.to_re ":") (re.* re.allchar) (str.to_re "@"))) (re.* (re.++ (str.to_re ".") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (re.opt (re.++ (re.opt (re.++ (str.to_re "?") (re.* re.allchar))) (re.opt (re.++ (str.to_re "#") (re.* re.allchar))) (str.to_re "/") (re.* re.allchar))) (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 0 61) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))))
; /Referer\u{3a}\u{20}[\u{20}-\x7E]*?\/wp\u{2d}admin\/[a-z\d\u{2d}]+?\.php\r\n/Hi
(assert (str.in_re X (re.++ (str.to_re "/Referer: ") (re.* (re.range " " "~")) (str.to_re "/wp-admin/") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ".php\u{0d}\u{0a}/Hi\u{0a}"))))
; (-?(\d*\.\d{1}?\d*|\d{1,}))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ (re.* (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.+ (re.range "0" "9"))))))
; Host\x3AHost\u{3a}fhfksjzsfu\u{2f}ahm\.uqsHost\x3Afowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (str.to_re "Host:Host:fhfksjzsfu/ahm.uqsHost:fowclxccdxn/uxwn.ddy\u{0a}")))
(assert (< 200 (str.len X)))
(check-sat)
