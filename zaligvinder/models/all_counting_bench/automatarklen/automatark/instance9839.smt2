(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[+-]?[0-9]+$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; client\x2Ebaigoo\x2Ecom\s+ised2k
(assert (str.in_re X (re.++ (str.to_re "client.baigoo.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ised2k\u{0a}"))))
; FTP.*www\x2Ewordiq\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "FTP") (re.* re.allchar) (str.to_re "www.wordiq.com\u{1b}\u{0a}")))))
; \u{22}reaction\x2Etxt\u{22}User-Agent\x3AnewsSpyAgentsmrtshpr-cs-
(assert (not (str.in_re X (str.to_re "\u{22}reaction.txt\u{22}User-Agent:newsSpyAgentsmrtshpr-cs-\u{13}\u{0a}"))))
; ((http|ftp|https):\/\/w{3}[\d]*.|(http|ftp|https):\/\/|w{3}[\d]*.)([\w\d\._\-#\(\)\[\]\\,;:]+@[\w\d\._\-#\(\)\[\]\\,;:])?([a-z0-9]+.)*[a-z\-0-9]+.([a-z]{2,3})?[a-z]{2,6}(:[0-9]+)?(\/[\/a-z0-9\._\-,]+)*[a-z0-9\-_\.\s\%]+(\?[a-z0-9=%&\.\-,#]+)?
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://") ((_ re.loop 3 3) (str.to_re "w")) (re.* (re.range "0" "9")) re.allchar) (re.++ (re.union (str.to_re "http") (str.to_re "ftp") (str.to_re "https")) (str.to_re "://")) (re.++ ((_ re.loop 3 3) (str.to_re "w")) (re.* (re.range "0" "9")) re.allchar)) (re.opt (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ",") (str.to_re ";") (str.to_re ":") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ",") (str.to_re ";") (str.to_re ":") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) re.allchar)) (re.+ (re.union (re.range "a" "z") (str.to_re "-") (re.range "0" "9"))) re.allchar (re.opt ((_ re.loop 2 3) (re.range "a" "z"))) ((_ re.loop 2 6) (re.range "a" "z")) (re.opt (re.++ (str.to_re ":") (re.+ (re.range "0" "9")))) (re.* (re.++ (str.to_re "/") (re.+ (re.union (str.to_re "/") (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-") (str.to_re ","))))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re ".") (str.to_re "%") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (str.to_re "?") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ".") (str.to_re "-") (str.to_re ",") (str.to_re "#"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)