import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.stream.Stream;

public class Lambdas {

    static void compare1(String[] arr) {
        Arrays.sort(arr, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                return o1.toUpperCase().compareTo(o2.toUpperCase());
            }
        });
        for(String elem : arr) {
            System.out.println(elem);
        }
    }
    static void compare2(String[] arr) {
        Stream.of(arr)
                .sorted((o1, o2) -> o1.toUpperCase().compareTo(o2.toUpperCase()))
                .forEach(System.out::println);
    }

    public static void main(String[] args) {
        {
            String[] test = {"zelen", "GULA", "Srdce", "zALUD"};
            compare1(test);
            System.out.println(List.of(test));
        }
        {
            String[] test = {"zelen", "GULA", "Srdce", "zALUD"};
            compare2(test);
            System.out.println(List.of(test));
        }
    }
}


