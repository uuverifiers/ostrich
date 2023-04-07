(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (http):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+(\\.[\\w\\-_]+)(\\/)([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?^=%&/~\\+#]+)(\\/)((\\d{8}-)|(\\d{9}-)|(\\d{10}-)|(\\d{11}-))+([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?+html^])?
(assert (str.in_re X (re.++ (str.to_re "http:\u{5c}/\u{5c}/") (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))) (re.+ (re.++ (str.to_re "\u{5c}") re.allchar (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))))) (str.to_re "\u{5c}/\u{5c}/") (re.+ (re.union (re.++ (str.to_re "\u{5c}") ((_ re.loop 8 8) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 9 9) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 10 10) (str.to_re "d")) (str.to_re "-")) (re.++ (str.to_re "\u{5c}") ((_ re.loop 11 11) (str.to_re "d")) (str.to_re "-")))) (re.opt (re.++ (re.* (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re ".") (str.to_re ",") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ":") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#"))) (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re "@") (str.to_re "?") (str.to_re "+") (str.to_re "h") (str.to_re "t") (str.to_re "m") (str.to_re "l") (str.to_re "^")))) (str.to_re "\u{0a}\u{5c}") re.allchar (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "_"))) (re.* (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re ".") (str.to_re ",") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re ":") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#"))) (re.+ (re.union (str.to_re "\u{5c}") (str.to_re "w") (re.range "\u{5c}" "\u{5c}") (str.to_re "@") (str.to_re "?") (str.to_re "^") (str.to_re "=") (str.to_re "%") (str.to_re "&") (str.to_re "/") (str.to_re "~") (str.to_re "+") (str.to_re "#"))))))
; FTP\s+\x2FNFO\x2CRegistered\s+Server\s+www\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/NFO,Registered") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Server") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.internet-optimizer.com\u{0a}")))))
; httphost[^\n\r]*www\x2Emaxifiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "httphost") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "www.maxifiles.com\u{0a}")))))
; ^(0|(\+)?([1-9]{1}[0-9]{0,3})|([1-5]{1}[0-9]{1,4}|[6]{1}([0-4]{1}[0-9]{3}|[5]{1}([0-4]{1}[0-9]{2}|[5]{1}([0-2]{1}[0-9]{1}|[3]{1}[0-5]{1})))))$
(assert (str.in_re X (re.++ (re.union (str.to_re "0") (re.++ (re.opt (str.to_re "+")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "5")) ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "6")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "4")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "5")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (str.to_re "3")) ((_ re.loop 1 1) (re.range "0" "5")))))))))) (str.to_re "\u{0a}"))))
(check-sat)