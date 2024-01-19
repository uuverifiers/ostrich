(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}rmf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rmf/i\u{0a}"))))
; ^(((([1]?\d)?\d|2[0-4]\d|25[0-5])\.){3}(([1]?\d)?\d|2[0-4]\d|25[0-5]))|([\da-fA-F]{1,4}(\:[\da-fA-F]{1,4}){7})|(([\da-fA-F]{1,4}:){0,5}::([\da-fA-F]{1,4}:){0,5}[\da-fA-F]{1,4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.++ (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re "."))) (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "1")) (re.range "0" "9"))) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5")))) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) ((_ re.loop 7 7) (re.++ (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")))))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) (str.to_re "::") ((_ re.loop 0 5) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))))
; (\s|\n|^)(\w+://[^\s\n]+)
(assert (not (str.in_re X (re.++ (re.union (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "://") (re.+ (re.union (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; (^\d*\.?\d*[1-9]+\d*$)|(^[1-9]+\d*\.\d*$)
(assert (not (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9")))))))
; SpyAgent\s+daosearch\x2Ecom\s+X-Mailer\u{3a}\s+zmnjgmomgbdz\u{2f}zzmw\.gzt
(assert (not (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "daosearch.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "zmnjgmomgbdz/zzmw.gzt\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
